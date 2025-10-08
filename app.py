from flask import Flask, render_template, request
from model import get_recommendations

app = Flask(__name__)

@app.route('/')
def welcome():
    return render_template('welcome.html')

@app.route('/input')
def input_page():
    return render_template('input.html')

@app.route('/recommend', methods=['POST'])
def recommend():
    view_count = request.form['view_count']
    tags = request.form['tags']
    channel = request.form['channel']
    channel_follower_count = request.form['channel_follower_count']

    recommendations = get_recommendations(view_count, tags, channel, channel_follower_count)

    return render_template('output.html', songs=recommendations)

if __name__ == '__main__':
    app.run(debug=True)