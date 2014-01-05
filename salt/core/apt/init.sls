/etc/apt/sources.list:
  file.absent

sources-debian:
  file.managed:
    - name: /etc/apt/sources.list.d/01-debian.list
    - source: salt://core/apt/sources.list.d/01-debian.list
    - template: jinja

sources-salt:
  file.managed:
    - name: /etc/apt/sources.list.d/50-salt.list
    - source: salt://core/apt/sources.list.d/50-salt.list
    - template: jinja
  cmd.wait:
    - name: wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
    - watch:
      - file: sources-salt
