from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def main():
  # Define the page title and content with styling
  page_title = "Sample Flask Project"
  body_content = "This is a sample flask project"
  body_style = "color: red; background-color: lightgray; padding: 10px;"
  
  # Pass variables to the template
  return render_template('index.html', page_title=page_title, body_content=body_content, body_style=body_style)

if __name__ == "__main__":
  app.run(host='0.0.0.0', port=8080, debug=True, threaded=True)
