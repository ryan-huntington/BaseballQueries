USER_NAME = 'root'
USER_PASSWORD = 'csi3335rocks'
HOST_NAME = 'localhost'
DB_NAME = 'GLAR'

# Connection URI uses pymysql
class Config(object):
    SQLALCHEMY_DATABASE_URI = 'mariadb+pymysql://{}:{}@{}/{}?charset=utf8mb4'.format(USER_NAME, USER_PASSWORD, HOST_NAME, DB_NAME)
    SECRET_KEY='super-secret'