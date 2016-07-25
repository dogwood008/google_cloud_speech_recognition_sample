FROM centos:latest

MAINTAINER dogwood008

# Install packages for building ruby
RUN yum update
RUN yum -y install make tar git wget gcc-c++ openssl-devel readline-devel gdbm-devel libffi-devel zlib-devel curl-devel procps autoconf sudo bzip2

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN source /root/.bashrc

# Install ruby 2.3.1
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.3.1
RUN rbenv global 2.3.1
RUN rbenv rehash
RUN eval "$(rbenv init -)"
RUN echo 'gem: --no-rdoc --no-ri' >> /root/.gemrc
RUN /root/.rbenv/shims/gem install bundler


# Install sox
RUN yum -y install vorbis-tools sox 

# Clone repo
RUN mkdir -p /root/.ssh
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh

# Boot Server
RUN git clone https://github.com/dogwood008/google_cloud_speech_recognition_sample.git
RUN cd google_cloud_speech_recognition_sample &&\
      /root/.rbenv/shims/bundle install
RUN cd google_cloud_speech_recognition_sample &&\
      git checkout develop
CMD cd google_cloud_speech_recognition_sample &&\
      /root/.rbenv/shims/bundle exec ruby recog.rb
EXPOSE 4567
