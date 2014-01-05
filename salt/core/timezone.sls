timezone:
  pkg.installed:
    - name: tzdata

  file.managed:
    - name: /etc/timezone
    - template: jinja
    - contents: {{ salt["pillar.get"]("core.timezone", "America/Los_Angeles") }}
    - requires:
      - pkg: timezone

  cmd.wait:
    - name: cp -v /usr/share/zoneinfo/$(cat /etc/timezone) /etc/localtime
    - watch:
      - file: timezone
