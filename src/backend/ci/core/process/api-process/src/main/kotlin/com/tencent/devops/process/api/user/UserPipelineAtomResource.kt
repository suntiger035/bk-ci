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

package com.tencent.devops.process.api.user

import com.tencent.devops.common.api.auth.AUTH_HEADER_USER_ID
import com.tencent.devops.common.api.auth.AUTH_HEADER_USER_ID_DEFAULT_VALUE
import com.tencent.devops.common.api.pojo.Page
import com.tencent.devops.common.api.pojo.Result
import com.tencent.devops.process.pojo.PipelineAtomRel
import com.tencent.devops.store.pojo.atom.AtomProp
import io.swagger.annotations.Api
import io.swagger.annotations.ApiOperation
import io.swagger.annotations.ApiParam
import javax.servlet.http.HttpServletResponse
import javax.ws.rs.Consumes
import javax.ws.rs.GET
import javax.ws.rs.HeaderParam
import javax.ws.rs.POST
import javax.ws.rs.Path
import javax.ws.rs.PathParam
import javax.ws.rs.Produces
import javax.ws.rs.QueryParam
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType

@Api(tags = ["USER_PIPELINE_ATOM"], description = "用户-流水线-插件")
@Path("/user/pipeline")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
interface UserPipelineAtomResource {

    @ApiOperation("获取插件流水线相关信息列表")
    @GET
    @Path("/atoms/{atomCode}/rel/list")
    fun getPipelineAtomRelList(
        @ApiParam(value = "用户ID", required = true, defaultValue = AUTH_HEADER_USER_ID_DEFAULT_VALUE)
        @HeaderParam(AUTH_HEADER_USER_ID)
        userId: String,
        @ApiParam("插件标识", required = true)
        @PathParam("atomCode")
        atomCode: String,
        @ApiParam("插件版本号", required = false)
        @QueryParam("version")
        version: String?,
        @ApiParam("查询开始时间，格式yyyy-MM-dd HH:mm:ss", required = true)
        @QueryParam("startUpdateTime")
        startUpdateTime: String,
        @ApiParam("查询结束时间，格式yyyy-MM-dd HH:mm:ss", required = true)
        @QueryParam("endUpdateTime")
        endUpdateTime: String,
        @ApiParam("第几页", required = true, defaultValue = "1")
        @QueryParam("page")
        page: Int = 1,
        @ApiParam("每页多少条", required = true, defaultValue = "10")
        @QueryParam("pageSize")
        pageSize: Int = 10
    ): Result<Page<PipelineAtomRel>?>

    @ApiOperation("导出插件流水线相关信息csv文件")
    @POST
    @Path("/atoms/{atomCode}/rel/csv/export")
    fun exportPipelineAtomRelCsv(
        @ApiParam("userId", required = true)
        @HeaderParam(AUTH_HEADER_USER_ID)
        userId: String,
        @ApiParam("插件标识", required = true)
        @PathParam("atomCode")
        atomCode: String,
        @ApiParam("插件版本号", required = false)
        @QueryParam("version")
        version: String?,
        @ApiParam("查询开始时间，格式yyyy-MM-dd HH:mm:ss", required = true)
        @QueryParam("startUpdateTime")
        startUpdateTime: String,
        @ApiParam("查询结束时间，格式yyyy-MM-dd HH:mm:ss", required = true)
        @QueryParam("endUpdateTime")
        endUpdateTime: String,
        @Context
        response: HttpServletResponse
    )

    @ApiOperation("获取流水线下插件属性列表")
    @GET
    @Path("/projects/{projectId}/pipelines/{pipelineId}/atom/prop/list")
    fun getPipelineAtomPropList(
        @ApiParam(value = "用户ID", required = true, defaultValue = AUTH_HEADER_USER_ID_DEFAULT_VALUE)
        @HeaderParam(AUTH_HEADER_USER_ID)
        userId: String,
        @ApiParam("项目ID", required = true)
        @PathParam("projectId")
        projectId: String,
        @ApiParam("流水线ID", required = true)
        @PathParam("pipelineId")
        pipelineId: String
    ): Result<Map<String, AtomProp>?>
}
