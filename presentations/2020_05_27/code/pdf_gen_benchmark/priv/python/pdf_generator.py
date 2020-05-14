from weasyprint import HTML

def generate(html, file_name):
    return HTML(string=html.decode('utf-8')).write_pdf(file_name.decode('utf-8'))

