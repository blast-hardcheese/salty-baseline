include:
  - viridian.gitolite
  - viridian.users

{% set deployment_home = "/var/people/deployment" %}
{% set deployment_key_path = deployment_home + "/deployment_rsa" %}

deployment:
  user.present:
    - system: True
    - password: '*'
    - shell: /bin/false
    - home: {{ deployment_home }}
    - require:
      - file: /var/people

{{ deployment_home }}/bin:
  file.directory:
    - user: deployment
    - group: deployment
    - require:
      - user: deployment

unzip:
  pkg.installed

{{ deployment_home }}/bin/play:
  file.managed:
    - mode: 755
    - user: deployment
    - group: deployment
    - source: salt://viridian/deps/play
    - require:
      - file: {{ deployment_home }}/bin
      - pkg: unzip
      - pkg: jdk

deployment-key:
  cmd.wait:
    - name: ssh-keygen -f {{ deployment_key_path }} -P ""
    - user: deployment
    - require:
      - user: deployment
    - watch:
      - user: deployment

supervisor:
  pkg:
    - installed
  service:
    - running
  cmd.wait:
    - name: supervisorctl update

jdk:
  pkg.installed:
    - name: openjdk-7-jdk
