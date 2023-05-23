
pipeline {
    agent any
  
    stages {
        stage('Checkout') {
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
        }
        stage('Transfer files to remote server') {
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
                            docker run -d -p 44322:80 -p 443:443 --name fgcatalogoapi fgcatalogoapi:qa
                        "
                    '''
                }
            }
        }        
    } 
    /*post {
        success {
            emailext body: "El pipeline de FiberGIS_CatalogoWeb se ha completado con exito.\n\nUltimo mensaje de commit: ${env.LAST_COMMIT_MESSAGE}\n\nCommit Id: ${env.LAST_COMMIT_HASH}.\n\nCatalogoWeb\nhttp://192.168.1.135:81",  
                     subject: 'FiberGIS_CatalogoWeb - Pipeline Exitoso',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
        failure {
            emailext body: 'El pipeline de FiberGIS_CatalogoWeb ha fallado.', 
                     subject: 'FiberGIS_CatalogoWeb - Pipeline Fallido - ERROR',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
    }*/
}

