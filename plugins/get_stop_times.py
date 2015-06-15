# -*- coding: utf-8 -*-

import urllib.parse
import urllib.request
import sys


def get_stop_times(station,
                    line='',
                    adaptados=0,
                    usuario='Anonimo',
                    idioma='en'):
    data={'parada':     station,
          'linea':  line,
          'adaptados': adaptados,
          'usuario': usuario,
          'idioma': idioma}
    data = urllib.parse.urlencode(data)
    binary_data = data.encode('ascii')
    path = 'https://www.emtvalencia.es/ciudadano/modules/mod_tiempo/busca_parada.php'
    req = urllib.request.Request(path, binary_data)
    req.add_header("Content-type", "application/x-www-form-urlencoded")
    page = urllib.request.urlopen(req).read().decode('ascii')
    return(page)



print(get_stop_times(sys.argv[1]))