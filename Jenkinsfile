node {
  def tag_name = env.BRANCH_NAME.split('/').last()
  checkout scm
  sh "docker build -t nulib/arch:${tag_name} ."
  docker.withRegistry('', 'docker-hub-credentials') {
    docker.image("nulib/arch:${tag_name}").push()
  }
  sh "docker tag \$(docker image ls -q --filter 'label=edu.northwestern.library.role=support' --filter 'label=edu.northwestern.library.app=DONUT' | head -1) nulib/arch-build:${tag_name}"
  sh "docker image prune -f"
}
