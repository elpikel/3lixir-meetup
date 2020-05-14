from weasyprint import HTML

def generate(html, i):
    return HTML(string=html.decode('utf-8')).write_pdf('/Users/arkadiuszplichta/Repositories/blockfi/reporting/template_'+str(i)+'.pdf')
