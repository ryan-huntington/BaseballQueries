from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from config import Config

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)
login = LoginManager(app)

from app import routes, models

with app.app_context():
    db.create_all()
    admin = db.session.query(models.User).filter_by(username="admin").one_or_none()

    if admin is None:
        admin = models.User(username="admin", is_admin=True)
        admin.set_password("123")

        db.session.add(admin)
        db.session.commit()