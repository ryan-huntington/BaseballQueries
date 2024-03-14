from app import app, db
from flask import render_template, flash, redirect, url_for, request
from flask_login import login_user, logout_user, current_user, login_required
from app.forms import LoginForm, SignupForm
from app.models import User, Team, Log
from datetime import datetime

@app.route('/')
@app.route('/index', methods=['GET'])
def index():
    if not current_user.is_authenticated:
        return redirect(url_for('login'))

    user_data = []
    log_data = []

    # Current user is admin? Get all user data
    if current_user.is_admin:
        user_data = User.query.all()
        log_data = Log.query.all()

    
    # Get all distinct team names
    team_tuple = db.engine.execute("SELECT DISTINCT team_name FROM teams ORDER BY team_name")
    teams = [row[0] for row in team_tuple]

    # Get all distinct years
    year_tuple = db.engine.execute("SELECT DISTINCT yearID FROM teams ORDER BY yearID DESC")
    years = [row[0] for row in year_tuple]

    return render_template('index.html', teams=teams, years=years, users=user_data, log_data=log_data)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
        
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is None or not user.check_password(form.password.data):
            flash('Invalid username or password')
        else:
            log = Log(content=f'[{datetime.now()}]: {user.username} logged in successfully')
            db.session.add(log)
            db.session.commit()
            
            login_user(user)
            return redirect(url_for('index'))
    return render_template('login.html', form=form)

@app.route('/signup', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))

    form = SignupForm()
    if form.validate_on_submit():
        if form.password.data != form.confirm_password.data:
            flash('Passwords do not match.')
        else:
            if User.query.filter_by(username=form.username.data).first() is None:
                user = User(username=form.username.data, is_admin=False)
                user.set_password(form.password.data)

                db.session.add(user)
                db.session.commit()

                log = Log(content=f'[{datetime.now()}]: {user.username} is signed up')
                db.session.add(log)
                db.session.commit()
            
                login_user(user)
                return redirect(url_for('index'))
            else:
                flash('Username already exists')
    return render_template('signup.html', form=form)

@app.route('/standing', methods=['GET'])
def standing():
    if not current_user.is_authenticated:
        return redirect(url_for('login'))
    
    args = request.args
    team_name = args.get('team', default='', type=str)
    year = args.get('year', default='', type=str)

    log = Log(content=f'[{datetime.now()}]: {current_user.username} retrieving standing of {team_name} in year {year}')
    db.session.add(log)
    db.session.commit()

    team_data = []
    division_name = None
    lg_ID = None
    team=None
    playoff_data = []

    if team_name == '' or year == '':
        flash('Team or year not properly specified.')
    
    # Year prior to 1969? Get team stats by league
    if int(year) < 1969:
        curr_team = db.engine.execute("SELECT team_W, team_L, team_G, team_R, WCWin, lgID, LgWin FROM teams WHERE \
            team_name=%s AND yearId=%s", team_name, year)
    else: # Else get team stats by division
        curr_team = db.engine.execute("SELECT team_W, team_L, team_G, team_R, WCWin, division_name, DivWin FROM teams \
            JOIN divisions USING (divID, lgID) WHERE team_name=%s AND yearId=%s", team_name, year)

    curr_team_row = curr_team.fetchone()

    if curr_team_row is None:
        flash('The '+team_name+' did not play in the year '+year)
    else:
        # Get team wins, losses, win percentage, runs, wc standing
        team_W=curr_team_row[0]
        team_L=curr_team_row[1]
        winPercent=str(round(team_W / curr_team_row[2], 1)*100)+'%'
        team_R=curr_team_row[3]
        WCWin=curr_team_row[4]

        made_playoffs = curr_team_row[6] == 'Y'
        all_teams_results = None

        # Year less than 1969?
        if int(year) < 1969: # Get team data by league
            lg_ID=curr_team_row[5]

            all_teams_results = db.engine.execute("SELECT team_name, yearID, team_W, team_L, team_G, team_R, WCWin FROM teams WHERE yearID=%s AND lgID=%s \
                ORDER BY team_rank", year, lg_ID)
        else: # Else get team data by division
            division_name=curr_team_row[5]

            # Get teams in current team division
            all_teams_results = db.engine.execute("SELECT team_name, yearID, team_W, team_L, team_G, team_R, WCWin FROM teams JOIN divisions USING (divID, lgID) \
                WHERE yearID=%s AND division_name=%s ORDER BY team_rank", year, division_name)

        list_teams = all_teams_results.fetchall()

        # Get top ranked team (first in list order)
        top_team_stats = list_teams[0]

        # For each team, calculate standing and add to team data
        for obj in list_teams:
            games_behind = ((top_team_stats[2]-obj[2]) + (obj[3]-top_team_stats[3])) / 2
            win_percent=str(round((obj[2] / obj[4]) * 100, 2))+'%'
            team_data.append(Team(obj[0], obj[1], obj[2], obj[3], win_percent, games_behind, obj[5], obj[6]))

        # Calculate games behind for current team
        games_behind = ((top_team_stats[2]-team_W)+(team_L-top_team_stats[3])) / 2

        # Team made playoffs? Get playoff data
        if made_playoffs:
            playoff_results = db.engine.execute("SELECT (SELECT DISTINCT team_name FROM teams WHERE teamID=teamIDwinner AND yearID=%s) as teamWinner, \
                (SELECT DISTINCT team_name FROM teams WHERE teamID=teamIDloser AND yearID=%s) as teamLoser, round FROM teams JOIN seriespost USING (yearId) \
                WHERE (teamID=teamIDwinner OR teamID=teamIDloser) AND team_name=%s AND yearId=%s",year, year, team_name, year)
            playoff_data = playoff_results.fetchall()

        team = Team(team_name, year, team_W, team_L, winPercent, games_behind, team_R, WCWin)
    return render_template('standing.html', team=team, data=team_data, playoff_data=playoff_data)

@app.route('/logout', methods=['POST'])
def logout():
    logout_user()
    return redirect(url_for('login'))