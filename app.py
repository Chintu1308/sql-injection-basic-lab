from flask import Flask, render_template, request, redirect, url_for, session
import database
import os

app = Flask(__name__)

# Use generated SECRET_KEY from Render env, or fallback for local dev
app.secret_key = os.environ.get('SECRET_KEY', 'sql_injection_lab_secret_key_local')

# Initialize the database tables and seed data on startup
database.init_db()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    query = None
    error = None
    if request.method == 'POST':
        user, query = database.login_user(request.form['username'], request.form['password'])
        if user:
            session['user_id']  = user[0]
            session['username'] = user[1]
            session['role']     = user[3]
            if session['role'] == 'administrator':
                return redirect(url_for('admin_dashboard'))
            else:
                return redirect(url_for('products'))
        else:
            error = "Invalid Credentials"

    return render_template('login.html', error=error, query=query)

@app.route('/products')
def products():
    search = request.args.get('search', '')
    results, query, error = database.search_products(search)
    return render_template('products.html',
                           results=results,
                           query=query,
                           error=error,
                           user=session if 'username' in session else None)

@app.route('/users')
def users():
    user_id = request.args.get('id', '')
    user, query = None, None
    if user_id:
        user, query = database.get_user_by_id(user_id)
    return render_template('users.html', user=user, query=query)

@app.route('/admin')
def admin_dashboard():
    if session.get('role') != 'administrator':
        return redirect(url_for('login'))
    stats = database.get_admin_stats()
    logs  = database.get_system_logs()
    return render_template('admin.html', stats=stats, logs=logs, user=session)

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, host='0.0.0.0', port=port)