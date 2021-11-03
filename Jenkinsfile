node {
  def tag_name = env.BRANCH_NAME.split('/').last()
  if ( tag_name == "main" ) {
    tag_name = "production"
  }
  checkout scm
  sh "docker build -t nulib/arch:${tag_name} ."
  docker.withRegistry('', 'docker-hub-credentials') {
    docker.image("nulib/arch:${tag_name}").push()
  }
  sh "docker tag \$(docker image ls -q --filter 'label=edu.northwestern.library.role=support' --filter 'label=edu.northwestern.library.app=Arch' | head -1) nulib/arch-build:${tag_name}"
  sh "docker image prune -f"
  sh "docker run -t -v /home/ec2-user/.aws:/root/.aws nulib/ebdeploy ${tag_name} arch"
}
