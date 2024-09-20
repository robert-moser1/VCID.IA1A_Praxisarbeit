from flask import Flask, render_template, request, redirect, url_for, jsonify, flash
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash
import logging
import jwt
from datetime import datetime, timedelta
from functools import wraps

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Root2024!@db:3306/ps5_games'
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['JWT_SECRET_KEY'] = 'your_jwt_secret_key'  # Add this for JWT token generation
app.config['JWT_EXPIRATION_DELTA'] = timedelta(hours=1)  # Token expiration time
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
migrate = Migrate(app, db)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# User loader function for Flask-Login
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Logging Konfiguration
logging.basicConfig(level=logging.DEBUG)

# Define the User and AccessToken models
class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)
    comments = db.relationship('Comment', back_populates='user', lazy=True)
    favorites = db.relationship('Favorite', back_populates='user', lazy=True, cascade="all, delete-orphan")
    ratings = db.relationship('Rating', back_populates='user', lazy=True)
    tokens = db.relationship('AccessToken', back_populates='user', lazy=True)

class AccessToken(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    token = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', back_populates='tokens')

class Game(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    rating = db.Column(db.Float)  # Rating als Fließkommazahl speichern
    comments = db.relationship('Comment', back_populates='game', lazy=True)
    favorites = db.relationship('Favorite', back_populates='game', lazy=True)
    ratings = db.relationship('Rating', back_populates='game', lazy=True)

class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    game_id = db.Column(db.Integer, db.ForeignKey('game.id'), nullable=False)
    user = db.relationship('User', back_populates='comments')
    game = db.relationship('Game', back_populates='comments')

class Favorite(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    game_id = db.Column(db.Integer, db.ForeignKey('game.id'), nullable=False)
    user = db.relationship('User', back_populates='favorites')
    game = db.relationship('Game', back_populates='favorites')

class Rating(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    game_id = db.Column(db.Integer, db.ForeignKey('game.id'), nullable=False)
    score = db.Column(db.Integer, nullable=False)  # Bewertung (1 bis 10)
    user = db.relationship('User', back_populates='ratings')
    game = db.relationship('Game', back_populates='ratings')

# Function to generate JWT token
def generate_access_token(user):
    payload = {
        'user_id': user.id,
        'exp': datetime.utcnow() + app.config['JWT_EXPIRATION_DELTA'],
        'iat': datetime.utcnow()
    }
    token = jwt.encode(payload, app.config['JWT_SECRET_KEY'], algorithm='HS256')
    return token

# Token validation decorator for secure API access
def token_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'message': 'Token is missing!'}), 403

        access_token = AccessToken.query.filter_by(token=token).first()
        if not access_token:
            return jsonify({'message': 'Invalid token!'}), 403

        try:
            decoded_token = jwt.decode(token, app.config['JWT_SECRET_KEY'], algorithms=['HS256'])
            user = User.query.get(decoded_token['user_id'])
            if not user:
                raise Exception('User not found')

            # Log the user in using Flask-Login
            login_user(user)

        except Exception as e:
            return jsonify({'message': 'Token is invalid or expired!'}), 403

        return f(*args, **kwargs)
    return decorated_function

# Profile view where the user can generate and manage tokens
@app.route('/profile')
@login_required
def profile():
    tokens = AccessToken.query.filter_by(user_id=current_user.id).all()
    return render_template('profile.html', tokens=tokens)

# Route to generate a new token
@app.route('/generate-token', methods=['POST'])
@login_required
def generate_token():
    token = generate_access_token(current_user)
    
    new_token = AccessToken(user_id=current_user.id, token=token)
    db.session.add(new_token)
    db.session.commit()
    
    flash('New access token generated', 'success')
    return redirect(url_for('profile'))

# Route to revoke a token
@app.route('/revoke-token/<int:token_id>', methods=['POST'])
@login_required
def revoke_token(token_id):
    token = AccessToken.query.get_or_404(token_id)
    
    if token.user_id != current_user.id:
        flash('Unauthorized action', 'danger')
        return redirect(url_for('profile'))
    
    db.session.delete(token)
    db.session.commit()
    
    flash('Access token revoked', 'success')
    return redirect(url_for('profile'))

# Example secured API route
@app.route('/api/games', methods=['GET'])
@token_required
def api_get_games():
    games = Game.query.all()
    games_data = [{'title': game.title, 'description': game.description, 'rating': game.rating} for game in games]
    return jsonify({'games': games_data})

# Original routes remain here
@app.route('/')
@login_required
def index():
    games = Game.query.all()
    return render_template('index.html', games=games)

@app.route('/game/<int:game_id>')
@login_required
def game_detail(game_id):
    game = Game.query.get_or_404(game_id)
    favorite_game_ids = [f.game_id for f in current_user.favorites]
    return render_template('game_detail.html', game=game, favorite_game_ids=favorite_game_ids)

@app.route('/game/<int:game_id>/comment', methods=['POST'])
@login_required
def add_comment(game_id):
    game = Game.query.get_or_404(game_id)
    comment_text = request.form.get('comment')
    if comment_text:
        new_comment = Comment(text=comment_text, user_id=current_user.id, game_id=game_id)
        db.session.add(new_comment)
        db.session.commit()
    return redirect(url_for('game_detail', game_id=game_id))

@app.route('/game/<int:game_id>/rate', methods=['POST'])
@login_required
def rate_game(game_id):
    game = Game.query.get_or_404(game_id)
    rating = request.form.get('rating')
    
    if rating:
        rating = int(rating)
        existing_rating = Rating.query.filter_by(user_id=current_user.id, game_id=game_id).first()
        if existing_rating:
            existing_rating.score = rating
        else:
            new_rating = Rating(user_id=current_user.id, game_id=game_id, score=rating)
            db.session.add(new_rating)
        db.session.commit()
        
        avg_rating = db.session.query(db.func.avg(Rating.score)).filter_by(game_id=game_id).scalar()
        game.rating = round(avg_rating)
        db.session.commit()
        
    return redirect(url_for('game_detail', game_id=game_id))

@app.route('/game/<int:game_id>/favorite', methods=['POST'])
@login_required
def toggle_favorite(game_id):
    game = Game.query.get_or_404(game_id)
    favorite = Favorite.query.filter_by(user_id=current_user.id, game_id=game_id).first()
    
    if favorite:
        db.session.delete(favorite)
        db.session.commit()
    else:
        new_favorite = Favorite(user_id=current_user.id, game_id=game_id)
        db.session.add(new_favorite)
        db.session.commit()

    return redirect(url_for('game_detail', game_id=game_id))

@app.route('/favorites')
@login_required
def favorites():
    user_favorites = Favorite.query.filter_by(user_id=current_user.id).all()
    favorite_games = [Game.query.get(favorite.game_id) for favorite in user_favorites]
    return render_template('favorites.html', favorite_games=favorite_games)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        logging.debug(f"Login attempt for username: {username}")
        user = User.query.filter_by(username=username).first()
        
        if user:
            logging.debug(f"User found: {user.username}")
            if check_password_hash(user.password, password):
                login_user(user)
                logging.debug("Login successful")
                return redirect(url_for('index'))
            else:
                logging.debug("Password incorrect")
                flash('Invalid username or password', 'danger')
        else:
            logging.debug("User not found")
            flash('Invalid username or password', 'danger')
    
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        hashed_password = generate_password_hash(password, method='sha256')
        
        if User.query.filter_by(username=username).first():
            flash('Username already exists', 'danger')
        elif User.query.filter_by(email=email).first():
            flash('Email already registered', 'danger')
        else:
            new_user = User(username=username, email=email, password=hashed_password)
            db.session.add(new_user)
            db.session.commit()
            flash('Account created successfully! Please log in.', 'success')
            return redirect(url_for('login'))
    
    return render_template('register.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))

@app.before_request
def ensure_login():
    # Skip authentication for API routes
    if request.endpoint and request.endpoint.startswith('api_'):
        return None
    
    if not current_user.is_authenticated and request.endpoint not in ['login', 'register']:
        return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)