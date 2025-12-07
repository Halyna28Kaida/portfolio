**How to install the libraries:**

    pip install -r requirements.txt

**How to run this project.**


Please, click on the link
https://www.volby.cz/pls/ps2017nss/ps3?xjazyk=CZ#1
and choose a region from column "Výběr
obce".
Copy the link you went to and follow the next steps.

This project is running with 2 arguments:

1. URL adress of specified region.
2. CSV file, where results will be written.

For example: 
python main.py 'https://www.volby.cz/pls/ps2017nss/ps32?xjazyk=CZ&xkraj=1&xnumnuts=1100' results_praha.csv

###### Warning!!!: Don't forget to put the URL adress in quotation marks.