node ('virtualbox') {
  def directory = "ansible-role-nsd"
  stage 'Clean up'
  deleteDir()
  stage 'Checkout'
  sh "if [ ! -d $directory ]; then mkdir $directory; fi"
  dir("$directory") {
    checkout scm
  }
  dir("$directory") {
    stage 'bundle'
    sh 'bundle install --path vendor/bundle'
    sh 'if vagrant box list | grep trombik/ansible-freebsd-10.3-amd64 >/dev/null; then echo "installed"; else vagrant box add trombik/ansible-freebsd-10.3-amd64; fi'

    stage 'bundle exec kitchen test'
    try {
      sh 'bundle exec kitchen destroy'
      sh "bundle exec kitchen converge '(remote-control-freebsd|default-freebsd)'"
      sh "bundle exec kitchen verify '(remote-control-freebsd|default-freebsd)'"
      sh 'bundle exec kitchen destroy'
      sh "bundle exec kitchen converge '(remote-control-openbsd|default-openbsd)'"
      sh "bundle exec kitchen verify '(remote-control-openbsd|default-openbsd)'"
    } finally {
      sh 'bundle exec kitchen destroy'
    }

    stage 'Notify'
    step([$class: 'GitHubCommitNotifier', resultOnFailure: 'FAILURE'])
  }
}