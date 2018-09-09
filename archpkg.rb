#!/usr/bin/env ruby

require 'open-uri'
require 'json'

# #[TODOS]#################
# funcionar depois refatorar
# associar o package com o numero para q, em vez de passar o numero, passe o pacote correspondente.

class Main
  # [global vars]-------------------------------

  def initialize
    raise 'Requires ruby >= 2.4.0' if RUBY_VERSION < '2.4.0'

    case ARGV[0]
    when '-S'
      install_pkg

    when '-Ss'
      search

    when '-h'
      help

    else
      puts 'Invalid Input! Try again...'
    end
  end

  def install_pkg
    # TODO
  end

  def search
    pacman_local_dir = '/var/lib/pacman/local/' # to read all packges installed
    packages_local = Dir.children(pacman_local_dir) # get all packages

    pkg = ARGV[1]

    puts ":: Seaching #{pkg} on aur..."
    url = "https://aur.archlinux.org/rpc/?v=5&type=search&arg=#{pkg}"
    buffer = open(url).read
    obj = JSON.parse(buffer)
    packages = obj['resultcount']
    packages_name = obj['results']

    names = packages_name.map { |result| result['Name'] }
    version = packages_name.map { |result| result['Version'] }
    description = packages_name.map { |result| result['Description'] }

    puts ":: Found #{packages} packages"
    count = 1
    exit unless packages > 0
    while count < packages

      name_and_version = "#{names[count]}-#{version[count]}"

      check = print('Installed ') if packages_local.include?(name_and_version) # é o que???? uehueheuheuheueh

      puts ":: \e[32m#{count}\e[0m aur/#{names[count]} \e[0;34m#{version[count]}\e[0m #{check}\n   #{description[count]}"
      count += 1
    end
    # range = (0..count).to_a
    # input_packages = STDIN.gets.chomp.to_i
    # install_pkg(input_packages) if range.include?(input_packages)
  end

  def help
    puts <<-HEREDOC

  Usage:
    -Ss <package>   Find a package
    -S  <package>   Install a package
    HEREDOC
  end
end

main = Main.new
