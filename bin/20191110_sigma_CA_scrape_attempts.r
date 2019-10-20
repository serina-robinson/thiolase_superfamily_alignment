# Install packages
pacman::p_load("webchem", "readxl", "tidyverse", "ChemmineR", "data.table", "plot3D", "plot3Drgl", "ggrepel",
               "jsonlite", "xml2", "rvest")

location_json <- "https://www.sigmaaldrich.com/catalog/rb_bf68711lgo?type=js&session=%3D3%3Dsrv%3D6%3Dsn%3DA65DD0712EC08F2218BC75F7488C9A61%3Dperc%3D100000%3Dol%3D0%3Dmul%3D1%3Dapp%3A1686b6dcc9c2ca9b%3D1&svrid=6&flavor=post&referer=https%3A%2F%2Fwww.sigmaaldrich.com%2Fcatalog%2Fsearch%3Finterface%3DAll%26term%3Dcarboxylic%2520acids%26N%3D0%26lang%3Den%26region%3DUS%26focus%3Dproduct%26mode%3Dmode%2Bmatchall&visitID=IDCMUCBJKJLFOPHFBAINPNKHBOJOOJOD&modifiedSince=1570722573627&app=1686b6dcc9c2ca9b"
try_again <- "https://www.sigmaaldrich.com/catalog/rb_bf68711lgo?type=js&session=%3D3%3Dsrv%3D5%3Dsn%3D513717794E87F55A91AB53AF796816A5%3Dperc%3D100000%3Dol%3D0%3Dmul%3D1%3Dapp%3A1686b6dcc9c2ca9b%3D1&svrid=5&flavor=post&referer=https%3A%2F%2Fwww.sigmaaldrich.com%2Fcatalog%2Fsearch%3Fterm%3Dcarboxylic%252520acids%26interface%3DAll%26N%3D0%26mode%3Dmatch%2520partialmax%26lang%3Den%26region%3DUS%26focus%3Dproduct&visitID=EEEHJFAOELLONEAOJJLNCDPNOKHNGGRH&modifiedSince=1570722573627&app=1686b6dcc9c2ca"
document <- jsonlite::fromJSON(location_json)
head(document)

url <- "https://www.sigmaaldrich.com/catalog/search?interface=All&term=carboxylic%20acids&N=0&lang=en&region=US&focus=product&mode=mode+matchall"

url2 <- "https://www.sigmaaldrich.com/catalog/rb_bf68711lgo?type=js&session=%3D3%3Dsrv%3D5%3Dsn%3D513717794E87F55A91AB53AF796816A5%3Dperc%3D100000%3Dol%3D0%3Dmul%3D1%3Dapp%3A1686b6dcc9c2ca9b%3D1&svrid=5&flavor=post&referer=https%3A%2F%2Fwww.sigmaaldrich.com%2Fcatalog%2Fsearch%3Fterm%3Dcarboxylic%252520acids%26interface%3DAll%26N%3D0%26mode%3Dmatch%2520partialmax%26lang%3Den%26region%3DUS%26focus%3Dproduct&visitID=EEEHJFAOELLONEAOJJLNCDPNOKHNGGRH&modifiedSince=1570722573627&app=1686b6dcc9c2ca"
sigma <- read_html(url2)
str(sigma)

url3 <- "https://www.sigmaaldrich.com/chemistry/chemistry-products.html?TablePage=16353353"
sigma <- read_html(url3)
sigma

tab <- "https://www.sigmaaldrich.com/rb_bf68711lgo?type=js&session=%3D3%3Dsrv%3D6%3Dsn%3DA65DD0712EC08F2218BC75F7488C9A61%3Dperc%3D100000%3Dol%3D0%3Dmul%3D1%3Dapp%3A1686b6dcc9c2ca9b%3D1&svrid=6&flavor=post&referer=https%3A%2F%2Fwww.sigmaaldrich.com%2Fchemistry%2Fchemistry-products.html%3FTablePage%3D16353353&visitID=IDCMUCBJKJLFOPHFBAINPNKHBOJOOJOD&modifiedSince=1570722573627&app=1686b6dcc9c2ca9b"
try3 <- jsonlite::fromJSON(tab)
