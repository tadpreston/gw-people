namespace :docker do
  desc "Push docker images to DockerHub"
  task :push_image do
    TAG = `git rev-parse --short HEAD`.strip

    puts "Building Docker image"
    sh "docker build -t tadpreston/gw-people:#{TAG} ."

    IMAGE_ID = `docker images | grep tadpreston\/gw-people | head -n1 | awk '{print $3}'`.strip

    puts "Tagging latest image"
    sh "docker tag #{IMAGE_ID} tadpreston/gw-people:latest"

    puts "Pushing Docker image"
    sh "docker push tadpreston/gw-people:#{TAG}"
    sh "docker push tadpreston/gw-people:latest"

    puts "Done"
  end

end
