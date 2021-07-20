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
import org.ajoberstar.grgit.Commit
import org.ajoberstar.grgit.Grgit
import org.springframework.boot.gradle.tasks.run.BootRun

// 设置为release包不带版本号
version = ""

plugins {
    kotlin("jvm")
    id("org.jetbrains.kotlin.plugin.spring")
    id("org.springframework.boot")
}

dependencies {
    api(project(":core:common:common-api"))
    api(project(":core:common:common-web"))
    api(project(":core:common:common-service"))
}

ext {
    var gitDir = file("$projectDir/../../../.git")
    project.extra["commit"] = if (gitDir.exists()) {
        gitDir = file("$projectDir/../../../")
        Grgit.open(gitDir).head()
    } else {
        null
    }
}

tasks {
    withType<BootRun> {
        jvmArgs = listOf("-Dspring.output.ansi.enabled=ALWAYS", "-Dfile.encoding=UTF-8")
    }

    register("copyVersionInfo") {
        val commit: Commit? = project.extra["commit"] as Commit?
        if (null != commit && File("$projectDir/src/main/resources").exists()) {
            File("$projectDir/src/main/resources/version.txt").writeText(
                """
                        id: ${commit.id}
                        message: ${commit.fullMessage}
                        user: ${commit.author.name}
                        email: ${commit.author.email}
                        time: ${commit.date}
                    """
            )
        }
        dependsOn("build")
    }

    register<Copy>("copyToRelease") {
        from("build/libs") {
            include("**/*.jar")
        }
        into("${rootDir}/release")
        outputs.upToDateWhen { false }
        dependsOn("bootJar")
        dependsOn("test")
    }

    getByName("build").dependsOn("copyToRelease")
}

configurations.forEach {
    it.exclude("ch.qos.logback", "logback-classic")
}

