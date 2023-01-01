from flask import Flask, render_template, request
from inverted_index import create_inverted_index, processQuery, file_path, search, search_results 
app = Flask(__name__)


@app.route('/', methods =['GET', 'POST'])
def home():
    
    return render_template('index.html', )

@app.route('/search', methods=['GET', 'POST'])
def result():
    if request.method == "POST":
        # getting input with name = fname in HTML form
        query = request.form.get("search_term")

        index = create_inverted_index(file_path=file_path)
        stemmed = processQuery(query)
        pre_result = search(stemmed, index)
        result_list = search_results(pre_result)

        return render_template('results.html',result_list=result_list)
    else: 
        return render_template('index.html')

