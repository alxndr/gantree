require 'colorize'

module Gantree
  class Docker < Base

    def initialize options
      check_credentials
      set_aws_keys
      @options = options
      @image_path = @options[:image_path]
      raise "Please provide an image path name in .gantreecfg ex. { 'image_path' : 'bleacher/cms' }" unless @image_path
      @tag = @options[:tag] ||= tag
    end

    def build
      puts "Building..."
      build_status = system("docker build -t #{@image_path}:#{@tag} .")
      if build_status.success?
        puts "Image Built: #{@image_path}:#{@tag}".green
        puts "gantree push --image-path #{@image_path} -t #{@tag}" unless @options[:hush]
        puts "gantree deploy app_name -t #{@tag}" unless @options[:hush]
      else
        puts "Error: Image was not built successfully".red
        puts "#{output}"
        exit 1
      end
    end

    def push
      puts "Pushing to #{@image_path}:#{@tag} ..."
      push_status = "docker push #{@image_path}:#{@tag}"
      if push_status.success?
        puts "Image Pushed: #{@image_path}:#{@tag}".green
        puts "gantree deploy app_name -t #{@tag}" unless @options[:hush]
      else
        puts "Error: Image was not pushed successfully".red
        puts "#{output}"
        exit 1
      end
    end
  end
end

