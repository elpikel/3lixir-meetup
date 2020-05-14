from flask import request, url_for
from flask_api import FlaskAPI, status, exceptions
from weasyprint import HTML

app = FlaskAPI(__name__)

@app.route("/", methods=['POST'])
def generate_pdf():
    pdf = HTML(string=request.data.get('html', '')).write_pdf()
    return pdf, status.HTTP_201_CREATED

if __name__ == "__main__":
    app.run(debug=False)
