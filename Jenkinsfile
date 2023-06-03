
pipeline {
    agent any
  
    stages {
        /*stage('Checkout') {
            steps {
                dir('C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi') {
                    git branch: 'master', url: 'https://x-token-auth:ATCTT3xFfGN0X2nYIHCzAuUDguJWyCZUJMyH1cvmPyUDPxFPLrQaPoMoDOnbbWuj2NUW53xhrnSyVhUCvb_bVNHGXEK5OJIGWOrw1FOmkIMmVncC6BWl5ha0Fp92iw94pwfoLZftNgJyREsY7hRoGWDVDbaQqqNJYvplGLGJQlnYgfcZlo6iVhY=3E2DBEDF@bitbucket.org/geosystems_ar/geocatalogoapi.git'
                    script {
                        def commit_hash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        def commit_message = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                        env.LAST_COMMIT_HASH = commit_hash
                        env.LAST_COMMIT_MESSAGE = commit_message
                    }                         
                }
            }
        }
        stage('Build') {
            steps {
                dir('C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi') {
                    bat 'dotnet build "C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi\\CatalogoFibergis.sln"'
                }
            }
        }          
        stage('Publish') {
            steps {
                dir('C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi') {
                   //bat 'dotnet publish "C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi\\CatalogoFibergis.sln" --output "C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi\\bin\\Release\\net6.0\\publish"'
                   bat 'dotnet publish "C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi\\CatalogoFibergis\\CatalogoFibergis.csproj" --output "C:\\Code\\FiberGIS_CatalogoApi\\PublishOutput"'
                }
            }
        }*/
        stage('SonarQubeAnalisis') {
            steps {
                // dir('C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi') {
                //     withSonarQubeEnv('sonarqubeserver') {
                //         bat 'dotnet sonarscanner begin /k:"FiberGIS_CatalogoApi" /d:sonar.login="jenkins" /d:sonar.host.url="http://192.168.1.149:9000" /d:sonar.exclusions="**/bin/**/*,**/obj/**/*"  /d:sonar.coverage.exclusions="**/Program.cs,**/Migrations/*"'
                //         bat 'dotnet build "C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi\\CatalogoFibergis.sln"'
                //         bat 'dotnet sonarscanner end /d:sonar.login="jenkins"'
                //     }
                // }
                script {
                    def scannerHome = tool 'sonarscanner' // Utiliza la instalación configurada en Global Tool Configurations
                    dir('C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi') {
                        bat "\"${scannerHome}\\bin\\dotnet-sonarscanner.bat\" begin /k:\"FiberGIS_CatalogoApi\" /d:sonar.login=\"jenkins\" /d:sonar.host.url=\"http://192.168.1.149:9000\" /d:sonar.exclusions=\"**/bin/**/*,**/obj/**/*\" /d:sonar.coverage.exclusions=\"**/Program.cs,**/Migrations/*\""
                        bat 'dotnet build "C:\\Code\\FiberGIS_CatalogoApi\\CatalogoApi\\CatalogoFibergis.sln"'
                        bat "\"${scannerHome}\\bin\\dotnet-sonarscanner.bat\" end /d:sonar.login=\"jenkins\""
                    }
                }                
            }
        }        
        /*stage('Transfer files to remote server') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    sh 'scp C:/Code/FiberGIS_CatalogoApi/Dockerfile geouser@192.168.1.135:/usr/src/app/fibergis_catalogoapi/'
                    sh 'scp C:/Code/FiberGIS_CatalogoApi/web.config geouser@192.168.1.135:/usr/src/app/fibergis_catalogoapi/'
                    //sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_catalogoapi && chmod -R 777 ./"'
                    // Eliminar contenido existente en el directorio CatalogoApi
                    sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_catalogoapi/CatalogoApi && rm -rf /usr/src/app/fibergis_catalogoapi/CatalogoApi/* && ls -la"'
                    // Copiar el directorio CatalogoApi y sus contenidos
                    sh 'scp -r C:/Code/FiberGIS_CatalogoApi/CatalogoApi geouser@192.168.1.135:/usr/src/app/fibergis_catalogoapi/'
                    // Eliminar archivos/directorios innecesarios en el directorio CatalogoApi
                    sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_catalogoapi/CatalogoApi && rm -rf .vs && rm -rf .git && rm -rf .gitignore && ls -la"'
                }
            }
        }
        stage('Build Docker image') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    sh '''
                        ssh geouser@192.168.1.135 "
                            cd /usr/src/app/fibergis_catalogoapi && 
                            if docker ps -a | grep fgcatalogoapi >/dev/null 2>&1; then docker stop fgcatalogoapi && 
                            docker rm fgcatalogoapi; fi && 
                            docker image rm -f fgcatalogoapi:qa || true && 
                            docker build -t fgcatalogoapi:qa --no-cache /usr/src/app/fibergis_catalogoapi
                        "
                    '''             
                }
            }
        } 
        stage('Run Docker container') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    sh '''
                        ssh geouser@192.168.1.135 " 
                            docker run -d --restart=always -p 44322:80 --name fgcatalogoapi fgcatalogoapi:qa
                        "
                    '''
                }
            }
        } */       
    } 
    /*post {
        success {
            emailext body: "La subida de FiberGIS_CatalogoApi se ha completado con exito.\n\n" +
                           "Ultimo mensaje de commit:\n" +
                           "${env.LAST_COMMIT_MESSAGE}\n\n" +
                           "Commit Id:\n" +
                           "${env.LAST_COMMIT_HASH}.\n\n" +
                           "API Catalogo\n" +
                           "http://192.168.1.135:44322/swagger/index.html\n\n" +
                           "Job Name: ${env.JOB_NAME}\n" +
                           "Build: ${env.BUILD_NUMBER}\n" +
                           "Console output: ${env.BUILD_URL}",  
                     subject: 'FiberGIS_CatalogoApi - Subida Exitosa',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
        failure {
            emailext body: "La subida de FiberGIS_CatalogoApi ha fallado.\n\n" +
                           "Job Name: ${env.JOB_NAME}\n" +
                           "Build: ${env.BUILD_NUMBER}\n" +
                           "Console output: ${env.BUILD_URL}", 
                     subject: 'FiberGIS_CatalogoApi - La subida ha Fallado - ERROR',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
    }*/
}

