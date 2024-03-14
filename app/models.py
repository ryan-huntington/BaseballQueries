from app import db, login
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    password_hash = db.Column(db.String(128))
    is_admin = db.Column(db.Boolean)

    def __repr__(self):
        return '<User {}>'.format(self.username)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

@login.user_loader
def load_user(id):
    return User.query.get(int(id))

class Team:
    def __init__(self, team_name, year, wins, losses, win_percent, games_behind, runs, wc_standing):
        self.team_name = team_name
        self.year = year
        self.wins = wins
        self.losses = losses
        self.win_percent = win_percent
        self.games_behind = games_behind
        self.runs = runs
        self.wc_standing = wc_standing

class Log(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(1024))

    def __repr__(self):
        return '<Log {}>'.format(self.content)