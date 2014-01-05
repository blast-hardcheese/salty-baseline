include:
  - viridian.users

{% set gitolite_repo = "git://github.com/sitaramc/gitolite" %}
{% set git_home = "/var/people/git" %}
{% set rawrbook_pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDchBTyJeBPe48+Is68A01rZt5jo/N6omqpDvh0EJh8GCRr3bSeIha8DTq/QHAVXG6WZXN5+eOdyn87r1ydOGM2u9atnVwlIZR+FOVIYYHsjxQqodcvZrp7351xw5O0ddOxPI+yaaK3NqvxKnLYChxQDr6vs6KSSVz75dCZ3Y2yrAK/5EY33TI7SVO8Rctp2hNisrdkAJ9TJtOxKlZxtfP5LJ38pfLrgQLK8OCKymKffCJa7EGVNhhy36mEvP3TPowOYkeFsUTohmaWHRWNczwFVweDpY3x3H+ZGNwHK7qMXrBAQrxBDIpHIU4L3k6l3TTpFEofUKTw4DfASJa9AarP /Users/blast/.ssh/blast_hardcheese-rawrbookpro" %}

git:
  user.present:
    - system: True
    - password: '*'
    - home: {{ git_home }}
    - require:
      - file: /var/people

{{ gitolite_repo }}:
  git.latest:
    - target: {{ git_home }}/gitolite
    - user: git
    - submodules: True
    - require:
      - user: git

{{ git_home }}/bin:
  file.directory:
    - user: git
    - group: git
    - require:
      - user: git

gitolite_install_cmd:
  cmd.wait:
    - name: {{ git_home }}/gitolite/install -to {{ git_home }}/bin
    - user: git
    - watch:
      - user: git
    - require:
      - git: {{ gitolite_repo }}
      - file: {{ git_home }}/bin

{{ git_home }}/blast_hardcheese.pub:
  file.managed:
    - contents: {{ rawrbook_pubkey }}
    - user: git
    - group: git
    - require:
      - user: git

gitolite setup -pk "{{ git_home }}/blast_hardcheese.pub":
  cmd.wait:
    - user: git
    - env:
      - PATH: {{ git_home }}/bin:/usr/bin:/bin
    - watch:
      - user: git
    - require:
      - file: {{ git_home }}/blast_hardcheese.pub
      - cmd: gitolite_install_cmd
