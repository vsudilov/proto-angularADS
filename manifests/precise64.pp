stage { 'first': before  => Stage['main'] }
stage { 'last':  require => Stage['main'] }
stage { 'pre': before => Stage['first'] }

class {
      'apt_update':     stage => pre;
      'system':         stage => first;
      'python_modules': stage => main;
      'bootstrap_js':    stage => main;
      'jquery':         stage => main;
      'run_webserver':   stage => last;
}

# Run apt-get update once on VM creation
# -----------------------------
class apt_update { 
  exec {
     "apt-get update":
        command => "/usr/bin/apt-get update && touch /root/apt-updated",
        creates => "/root/apt-updated";
       }
}

# System packages via apt
#------------------------------
class system{
  package {
      "build-essential":
          ensure => installed,
          provider => apt;
      "unzip":
          ensure => installed,
          provider => apt;
      # "sqlite3":
      #     ensure => installed,
      #     provider => apt;
      "python":
          ensure => installed,
          provider => apt;
      "python-dev":
          ensure => installed,
          provider => apt;
      "python-pip":
          ensure => installed,
          provider => apt;
      "rubygems":
          ensure => installed,
          provider => apt;
      # "libpq-dev":
      #     ensure => installed,
      #     provider => apt;
      "git":
          ensure => installed,
          provider => apt;
      "nginx":
          ensure => installed,
          provider => apt;
      # "python-scipy":
      #     ensure => installed,
      #     provider => apt;
      "gunicorn":
          ensure => installed,
          provider => apt;
  }


}

#bootstrap.js via .zip file on github
#------------------------------
class bootstrap_js {
  exec{
    "download_bootstrap":
      command => "/usr/bin/wget https://github.com/twbs/bootstrap/releases/download/v3.1.0/bootstrap-3.1.0-dist.zip -O /home/vagrant/bootstrap.zip",
      user => vagrant,
      creates => "/home/vagrant/bootstrap.zip";
  }
  exec {
    "unzip_and_move":
      cwd => "/home/vagrant/",
      command => "/usr/bin/unzip /home/vagrant/bootstrap.zip && /bin/mv /home/vagrant/dist /var/www/static",
      user => root,
      creates => "/var/www/static/dist",
      require => Exec["download_bootstrap"];
  }
}


#jquery2.0.2
#------------------------------
class jquery {
  exec {
    "download_jquery":
      command => "/usr/bin/wget http://code.jquery.com/jquery-2.0.2.min.js -O /var/www/static/js/jquery-2.0.2.min.js",
      creates => "/var/www/static/js/jquery-2.0.2.min.js";
  }
}



# Python modules via pip
#------------------------------
class python_modules{
  package {
      # "numpy":
      #     ensure => "1.6.1",
      #     provider => pip;
      "Flask":
          ensure => installed,
          provider => pip;
      # "xlrd":
      #     ensure => installed,
      #     provider => pip;
      # "py2neo":
      #     ensure => installed,
      #     provider => pip;
      # "flask-wtf":
      #     ensure => installed,
      #     provider => pip;
      # "flask-mail":
      #     ensure => installed,
      #     provider => pip;
      # "pygeoip":
      #     ensure => installed,
      #     provider => pip;
  }
}



class run_webserver {
  file {'/etc/nginx/nginx.conf':
    source => "/var/www/manifests/nginx.conf",
    owner => root,
    group => root;
  }

  exec { "restart_nginx":
    command => "/etc/init.d/nginx restart",
    user => root,
    require => File['/etc/nginx/nginx.conf'];
  }
  exec { "start_gunicorn":
    command => "/usr/bin/gunicorn -c /var/www/manifests/gunicorn.conf.py app:app",
    user => vagrant,
    cwd => "/var/www",
    require => Exec['restart_nginx'];
  }
}
