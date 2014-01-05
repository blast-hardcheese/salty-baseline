{% set tunnel_home = "/var/people/tunnel" %}
{% set rawrbook_pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDchBTyJeBPe48+Is68A01rZt5jo/N6omqpDvh0EJh8GCRr3bSeIha8DTq/QHAVXG6WZXN5+eOdyn87r1ydOGM2u9atnVwlIZR+FOVIYYHsjxQqodcvZrp7351xw5O0ddOxPI+yaaK3NqvxKnLYChxQDr6vs6KSSVz75dCZ3Y2yrAK/5EY33TI7SVO8Rctp2hNisrdkAJ9TJtOxKlZxtfP5LJ38pfLrgQLK8OCKymKffCJa7EGVNhhy36mEvP3TPowOYkeFsUTohmaWHRWNczwFVweDpY3x3H+ZGNwHK7qMXrBAQrxBDIpHIU4L3k6l3TTpFEofUKTw4DfASJa9AarP /Users/blast/.ssh/blast_hardcheese-rawrbookpro" %}

/var/people:
  file.directory:
    - makedirs: True

tunnel:
  user.present:
    - password: '*'
    - shell: /bin/false
    - home: {{ tunnel_home }}
    - system: True
    - require:
      - file: /var/people

{{ tunnel_home }}/.ssh:
  file.directory:
    - mode: 700
    - user: tunnel
    - group: tunnel
    - require:
      - user: tunnel

tunnel-authorized_keys:
  file.managed:
    - name: {{ tunnel_home }}/.ssh/authorized_keys
    - user: tunnel
    - mode: 600
    - contents: {{ rawrbook_pubkey }}
    - replace: False
    - require:
      - file: {{ tunnel_home }}/.ssh

tunnel-keygen:
  cmd.wait:
    - name: ssh-keygen -f {{ tunnel_home }}/.ssh/tunnel-id_rsa -P '' && cat {{ tunnel_home }}/.ssh/tunnel-id_rsa.pub >> {{ tunnel_home }}/.ssh/authorized_keys
    - require:
      - file: tunnel-authorized_keys
    - watch:
      - user: tunnel
