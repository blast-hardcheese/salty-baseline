locales:
  pkg:
    - installed

  file.managed:
    - name: /etc/locale.gen
    - source: salt://core/locales/locale.gen
    - template: jinja
    - require:
      - pkg: locales

  cmd.wait:
    - name: /usr/sbin/locale-gen
    - watch:
      - file: locales
