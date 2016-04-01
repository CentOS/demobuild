# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#
require 'inifile'

hosts = [
    {
        "name" => "minnow1.democluster.osas",
        "instance_type" => "t2.micro",
    },
    {
        "name" => "minnow2.democluster.osas",
        "instance_type" => "t2.micro",
    },
    {
        "name" => "minnow3.democluster.osas",
        "instance_type" => "t2.micro",
    },
    {
        "name" => "minnow4.democluster.osas",
        "instance_type" => "t2.micro",
    },
    {
        "name" => "minnow5.democluster.osas",
        "instance_type" => "t2.micro",
    },
    {
        "name" => "minnow6.democluster.osas",
        "instance_type" => "t2.micro",
    },
]

aws_creds = IniFile.load(File.expand_path('~/.aws/credentials'))
aws_config = IniFile.load(File.expand_path('~/.aws/config'))

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "dummy"
  config.ssh.pty = true

  config.vm.provider :aws do |aws, override|
      aws.access_key_id = aws_creds['default']['aws_access_key_id']
      aws.secret_access_key= aws_creds['default']['aws_secret_access_key']
      aws.region = aws_config['default']['region']

      aws.ami = "ami-d440a6e7"
      aws.associate_public_ip = true
      aws.keypair_name="centos"
      aws.user_data = "#!/bin/bash\nsed -i -e 's/^Defaults.*requiretty/# Defaults requiretty/g' /etc/sudoers"

      aws.block_device_mapping = [
          {
            'DeviceName' => "/dev/sda1",
            'Ebs.DeleteOnTermination' => true,
          }
      ]

      aws.subnet_id=aws_config['vagrant']['subnet']
      override.ssh.username = "centos"
      override.ssh.private_key_path = "aws.pem"
  end

  hosts.each_with_index do |host,idx|
    config.vm.define host['name'] do | config2 |
        config2.vm.provider :aws do |aws, override|
            aws.instance_type = host['instance_type']
        end

        if idx == hosts.size - 1
            config2.vm.provision "ansible" do |ansible|
                ansible.playbook = "site.yml"
                ansible.limit = "all"
            end #config
        end #if
    end
  end #hosts.each
end #Vagrant
