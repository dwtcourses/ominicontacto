# -*- coding: utf-8 -*-

import os

AMI_USER = os.getenv('AMI_USER')
AMI_PASSWORD = os.getenv('AMI_PASSWORD')
ASTERISK_HOSTNAME = os.getenv('ASTERISK_HOSTNAME')
ASTERISK_IP = os.getenv('ASTERISK_IP')
ASTERISK_LOCATION = os.getenv('ASTERISK_LOCATION')
DIALER_IP = os.getenv('DIALER_IP')
DIALER_HOSTNAME = os.getenv('WOMBAT_HOSTNAME')
EPHEMERAL_USER_TTL = int(os.getenv('EPHEMERAL_USER_TTL'))
INSTALL_PREFIX = os.getenv('INSTALL_PREFIX')
KAMAILIO_IP = os.getenv('KAMAILIO_IP')
KAMAILIO_HOSTNAME = os.getenv('KAMAILIO_HOSTNAME')
KAMAILIO_LOCATION = os.getenv('KAMAILIO_LOCATION')
POSTGRES_HOST = os.getenv('PGHOST')
POSTGRES_DATABASE = os.getenv('PGDATABASE')
POSTGRES_USER = os.getenv('PGUSER')
OML_OMNILEADS_IP = os.getenv('OMNILEADS_IP')
OML_EXTERNAL_PORT = int(os.getenv('EXTERNAL_PORT'))
NGINX_HOSTNAME = os.getenv('NGINX_HOSTNAME')
SESSION_COOKIE_AGE = int(os.getenv('SESSION_COOKIE_AGE'))
KAMAILIO_MODULES_LOCATION = os.getenv('KAMAILIO_MODULES_LOCATION')

# Credenciales para wombat API

OML_WOMBAT_USER = os.getenv('WOMBAT_USER')
OML_WOMBAT_PASSWORD = os.getenv('WOMBAT_PASSWORD')


ALLOWED_HOSTS = [
    "*",
]

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 's1+*bfrvb@=k@c&9=pm!0sijjewneu5p5rojil#q+!a2y&as-4'

# Datos de conexión de base db postgresql
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'HOST': POSTGRES_HOST,
        'PORT': 5432,
        'NAME': POSTGRES_DATABASE,
        'USER': POSTGRES_USER,
        'CONN_MAX_AGE': 300,
        'ATOMIC_REQUESTS': True,
    }
}

# Ubicaciones de staticos y media
STATIC_ROOT = "{0}static".format(INSTALL_PREFIX)
MEDIA_ROOT = "{0}media_root".format(INSTALL_PREFIX)

# IPs y hostnames
OML_KAMAILIO_IP = "{0}/255.255.255.255".format(KAMAILIO_IP)
OML_ASTERISK_HOSTNAME = "root@{0}".format(ASTERISK_HOSTNAME)

# Comandos que se ejecutan desde django
OML_RELOAD_CMD = 'ssh root@{0} \'/usr/sbin/asterisk -rx "core reload"\''.format(ASTERISK_HOSTNAME)

# URL externas
OML_GRABACIONES_URL = "https://{0}:{1}/grabaciones".format(NGINX_HOSTNAME, OML_EXTERNAL_PORT)
OML_WOMBAT_URL = "http://{0}:8080/wombat".format(DIALER_HOSTNAME)

# Ubicaciones de archivos
OML_SIP_FILENAME = "{0}/etc/asterisk/oml_sip_endpoints.conf".format(ASTERISK_LOCATION)
OML_QUEUES_FILENAME = "{0}/etc/asterisk/oml_queues.conf".format(ASTERISK_LOCATION)
OML_RUTAS_SALIENTES_FILENAME = "{0}/etc/asterisk/oml_extensions_outr.conf".format(ASTERISK_LOCATION)
OML_ASTERISK_REMOTEPATH = "{0}/etc/asterisk/".format(ASTERISK_LOCATION)
OML_BACKLIST_REMOTEPATH = "{0}/var/spool/asterisk/".format(ASTERISK_LOCATION)
OML_WOMBAT_FILENAME = "{0}wombat-json/".format(INSTALL_PREFIX)

OML_KAMAILIO_HOSTNAME = "root@{0}".format(KAMAILIO_HOSTNAME)
OML_KAMAILIO_CMD = "kamcmd -s {0}/run/kamailio/kamailio_ctl autheph.dump_secrets".format(
    KAMAILIO_LOCATION)

# Credenciales de AMI
ASTERISK = {
    'AMI_USERNAME': AMI_USER,  # Usuario para AMI
    'AMI_PASSWORD': AMI_PASSWORD,  # Password para usuario para AMI
    'HTTP_AMI_URL': "http://{0}:7088".format(ASTERISK_HOSTNAME),
}

# Seteo de logging
_logging_output_file = os.environ.get("OML_LOGFILE", "django.log")
assert os.path.split(_logging_output_file)[0] == "",\
    "La variable de entorno OML_LOGFILE solo debe contener " +\
    "el nombre del archivo, SIN directorios."
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': ('%(asctime)-15s [%(levelname)7s] '
                       '%(name)20s - %(message)s')
        },
    },
    'filters': {
    },
    'handlers': {
        'null': {
            'level': 'DEBUG',
            'class': 'logging.NullHandler',
        },
        'console': {
            'level': 'ERROR',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose'
        },
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': '{0}log/{1}'.format(INSTALL_PREFIX, _logging_output_file),
            'formatter': 'verbose'
        },
    },
    'loggers': {
        '': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
        },
    },
    'django.security.DisallowedHost': {
        'handlers': ['mail_admins'],
        'level': 'CRITICAL',
        'propagate': False,
    },
}

# Defender variables
DEFENDER_BEHIND_REVERSE_PROXY = True
DEFENDER_LOGIN_FAILURE_LIMIT = 1
DEFENDER_DISABLE_IP_LOCKOUT = True
DURACION_ASIGNACION_CONTACTO_PREVIEW = 30

# Comando y paths de audios del sistema
TMPL_OML_AUDIO_CONVERSOR = ["sox", "-t", "wav", "<INPUT_FILE>",
                            "-r", "8k", "-c", "1", "-e", "signed-integer",
                            "-t", "wav", "<OUTPUT_FILE>"]
TMPL_OML_AUDIO_CONVERSOR_EXTENSION = ".wav"
ASTERISK_AUDIO_PATH = "{0}/var/lib/asterisk/sounds/".format(ASTERISK_LOCATION)
OML_AUDIO_FOLDER = "oml/"

# Formato de grabaciones
MONITORFORMAT = os.getenv('MONITORFORMAT')
# Calificacion de agenda
CALIFICACION_REAGENDA = os.getenv('CALIFICACION_REAGENDA')

CONSTANCE_CONFIG = {
    'KEYS_SERVER_HOST': ('', 'KEYS_SERVER_HOST', str),
    'SSL_CERT_FILE': ('', 'SSL_CERT_FILE', str),
    'CLIENT_NAME': ('', 'CLIENT_NAME', str),
    'CLIENT_KEY': ('', 'CLIENT_KEY', str),
    'CLIENT_PASSWORD': ('', 'CLIENT_PASSWORD', str),
    'CLIENT_EMAIL': ('', 'CLIENT_EMAIL', str),
    'CLIENT_PHONE': ('', 'CLIENT_PHONE', str),
}
