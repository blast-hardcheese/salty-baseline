include:
  - viridian.servers.deployment

{% set deployment_home = "/var/people/deployment" %}
{% set deployment_key_path = deployment_home + "/deployment_rsa" %}

blog-repo:
  git.latest:
    - name: git@localhost:blog
    - target: {{ deployment_home }}/servers/blog
    - identity: {{ deployment_key_path }}
    - user: deployment
    - require:
      - user: deployment
      - cmd: deployment-key

  cmd.wait:
    - name: {{ deployment_home }}/bin/play clean stage
    - cwd: {{ deployment_home }}/servers/blog
    - user: deployment
    - watch:
      - git: blog-repo

/etc/supervisor/conf.d/blog.conf:
  file.managed:
    - source: salt://viridian/root/etc/supervisor/conf.d/blog.conf
    - mode: 644
    - require:
      - pkg: supervisor

extend:
  supervisor:
    cmd:
      - watch:
        - file: /etc/supervisor/conf.d/blog.conf

restart-blog:
  cmd.wait:
    - name: supervisorctl restart blog
    - watch:
      - cmd: blog-repo
