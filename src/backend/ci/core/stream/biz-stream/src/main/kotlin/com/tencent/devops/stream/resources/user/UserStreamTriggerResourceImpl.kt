/*
 * Tencent is pleased to support the open source community by making BK-CI 蓝鲸持续集成平台 available.
 *
 * Copyright (C) 2019 THL A29 Limited, a Tencent company.  All rights reserved.
 *
 * BK-CI 蓝鲸持续集成平台 is licensed under the MIT license.
 *
 * A copy of the MIT License is included in this file.
 *
 *
 * Terms of the MIT License:
 * ---------------------------------------------------
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of
 * the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
 * NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.tencent.devops.stream.resources.user

import com.tencent.devops.common.api.exception.ParamBlankException
import com.tencent.devops.common.api.pojo.Result
import com.tencent.devops.common.web.RestResource
import com.tencent.devops.common.web.form.FormBuilder
import com.tencent.devops.common.web.form.models.Form
import com.tencent.devops.process.yaml.v2.models.Variable
import com.tencent.devops.stream.api.user.UserStreamTriggerResource
import com.tencent.devops.stream.permission.StreamPermissionService
import com.tencent.devops.stream.pojo.ManualTriggerInfo
import com.tencent.devops.stream.pojo.ManualTriggerReq
import com.tencent.devops.stream.pojo.StreamGitYamlString
import com.tencent.devops.stream.pojo.TriggerBuildReq
import com.tencent.devops.stream.pojo.TriggerBuildResult
import com.tencent.devops.stream.pojo.V2BuildYaml
import com.tencent.devops.stream.service.StreamPipelineService
import com.tencent.devops.stream.service.StreamYamlService
import com.tencent.devops.stream.trigger.ManualTriggerService
import com.tencent.devops.stream.util.GitCommonUtils
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired

@RestResource
class UserStreamTriggerResourceImpl @Autowired constructor(
    private val manualTriggerService: ManualTriggerService,
    private val streamPipelineService: StreamPipelineService,
    private val permissionService: StreamPermissionService,
    private val streamYamlService: StreamYamlService
) : UserStreamTriggerResource {

    override fun triggerStartup(
        userId: String,
        pipelineId: String,
        triggerBuildReq: ManualTriggerReq
    ): Result<TriggerBuildResult> {
        val gitProjectId = GitCommonUtils.getGitProjectId(triggerBuildReq.projectId)
        checkParam(userId)
        permissionService.checkStreamAndOAuthAndEnable(userId, triggerBuildReq.projectId, gitProjectId)
        return Result(
            manualTriggerService.triggerBuild(
                userId, pipelineId,
                TriggerBuildReq(
                    projectId = triggerBuildReq.projectId,
                    branch = triggerBuildReq.branch,
                    customCommitMsg = triggerBuildReq.customCommitMsg,
                    yaml = triggerBuildReq.yaml,
                    description = null,
                    commitId = triggerBuildReq.commitId,
                    payload = null,
                    eventType = null,
                    inputs = ManualTriggerService.parseInputs(triggerBuildReq.inputs)
                )
            )
        )
    }

    override fun getManualTriggerInfo(
        userId: String,
        projectId: String,
        pipelineId: String,
        branchName: String,
        commitId: String?
    ): Result<ManualTriggerInfo> {
        val gitProjectId = GitCommonUtils.getGitProjectId(projectId)
        checkParam(userId)

        val yaml = streamPipelineService.getYamlByPipeline(
            gitProjectId, pipelineId,
            if (commitId.isNullOrBlank()) {
                branchName
            } else {
                commitId
            }
        )
        if (yaml.isNullOrBlank()) {
            return Result(ManualTriggerInfo(yaml = null, schema = null))
        }

        val variables = manualTriggerService.parseManualVariables(
            userId, pipelineId,
            TriggerBuildReq(
                projectId = projectId,
                branch = branchName,
                customCommitMsg = null,
                yaml = yaml,
                description = null,
                commitId = commitId,
                payload = null,
                eventType = null,
                inputs = null
            )
        )

        if (variables.isNullOrEmpty()) {
            return Result(ManualTriggerInfo(yaml = yaml, schema = null))
        }

        return Result(ManualTriggerInfo(yaml = yaml, schema = parseVariablesToForm(variables)))
    }

    override fun checkYaml(userId: String, yaml: StreamGitYamlString): Result<String> {
        return streamYamlService.checkYaml(userId, yaml)
    }

    override fun getYamlByBuildId(userId: String, projectId: String, buildId: String): Result<V2BuildYaml?> {
        val gitProjectId = GitCommonUtils.getGitProjectId(projectId)
        checkParam(userId)
        return Result(streamYamlService.getYamlV2(gitProjectId, buildId))
    }

    @Deprecated("手动触发换新的接口拿取，后续看网关没有调用直接删除")
    override fun getYamlByPipeline(
        userId: String,
        projectId: String,
        pipelineId: String,
        branchName: String,
        commitId: String?
    ): Result<String?> {
        val gitProjectId = GitCommonUtils.getGitProjectId(projectId)
        checkParam(userId)
        val ref = if (commitId.isNullOrBlank()) {
            branchName
        } else {
            commitId
        }
        return Result(streamPipelineService.getYamlByPipeline(gitProjectId, pipelineId, ref))
    }

    companion object {
        private val logger = LoggerFactory.getLogger(UserStreamTriggerResourceImpl::class.java)

        fun parseVariablesToForm(variables: Map<String, Variable>): Form {
            val builder = FormBuilder().setTitle("").setDescription("")

            variables.forEach { (name, value) ->
            }

            return builder.build()
        }

        private fun checkParam(userId: String) {
            if (userId.isBlank()) {
                throw ParamBlankException("Invalid userId")
            }
        }
    }
}
