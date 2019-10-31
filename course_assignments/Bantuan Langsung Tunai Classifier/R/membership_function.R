library('plotly')

#lingustic variables
##Pendapatan = {Tinggi, Sedang, Rendah}
##Hutang = {Besar, Sedang, Kecil}
##BLT = {Ya, Tidak}

#membership functions
##independent variables
##pendapatan
pendapatan_tinggi <- function(pendapatan){
  a <- 1.1
  b <- 1.3
  if (pendapatan <= a){
    tinggi <- 0
  }else if (pendapatan > a & pendapatan < b){
    tinggi <- (pendapatan-a)/(b-a)
  }else if (pendapatan >= b){
    tinggi <- 1
  }
  tinggi
}
pendapatan_sedang <- function(pendapatan){
  a <- 0.55
  b <- 0.7
  c <- 1.2
  d <- 1.3
  if (pendapatan <= a | pendapatan >= d){
    sedang <- 0
  }else if (pendapatan > a & pendapatan < b){
    sedang <- (pendapatan-a)/(b-a)
  }else if (pendapatan > c & pendapatan < d){
    sedang <- -(pendapatan-d)/(d-c)
  }else{
    sedang <- 1
  }
  sedang
}
pendapatan_rendah <- function(pendapatan){
  a <- 0.5
  b <- 0.7
  if (pendapatan <= a){
    rendah <- 1
  }else if ( pendapatan > a & pendapatan < b){
    rendah <- (pendapatan-b)/(a-b)
  }else{
    rendah <- 0
  }
  rendah
}

##visualisasi membership function pendapatan
ranges1 <- seq(0, 2, length=10000)
ptinggi <- c()
psedang <- c()
prendah <- c()

for (i in 1:length(ranges1)){
  ptinggi[i] <- pendapatan_tinggi(ranges1[i])
  psedang[i] <- pendapatan_sedang(ranges1[i])
  prendah[i] <- pendapatan_rendah(ranges1[i])
}
data <- data.frame(ranges1, ptinggi, psedang, prendah)
vpendapatan <- plot_ly(data, x = ~ranges1,  y = ~ptinggi, name = 'tinggi', type = 'scatter', mode = 'lines')%>%
  add_trace(y = ~psedang, name = 'sedang', mode = 'lines') %>%
  add_trace(y = ~prendah, name = 'rendah', mode = 'lines') %>%
  layout(title = "Visualisasi Membership Function dari Pendapatan",
    xaxis = list(title = "Pendapatan"),
    yaxis = list (title = "P(x)"))
vpendapatan

##hutang
hutang_besar <- function(hutang){
  a <- 55
  b <- 60
  if (hutang <= a){
    besar <- 0
  }else if ( hutang > a & hutang < b){
    besar <- (hutang-a)/(b-a)
  }else{
    besar <- 1
  }
  besar
}
hutang_sedang <- function(hutang){
  a <- 35
  b <- 50
  c <- 65
  if (hutang <= a | hutang >= c){
    sedang <- 0
  }else if (hutang > a & hutang <= b){
    sedang <- (hutang-a)/(b-a)
  }else if (hutang > b & hutang <= c){
    sedang <- -(hutang-c)/(c-b)
  }
  sedang
}
hutang_kecil <- function(hutang){
  a <- 40
  b <- 45
  if (hutang <= a){
    kecil <- 1
  }else if (hutang > a & hutang < b){
    kecil <- (hutang-b)/(a-b)
  }else{
    kecil<- 0
  }
  kecil
}

##visualisasi membership function hutang
ranges2 <- seq(0, 100, length=10000)
hbesar <- c()
hsedang <- c()
hkecil <- c()

for (i in 1:length(ranges2)){
  hbesar[i] <- hutang_besar(ranges2[i])
  hsedang[i] <- hutang_sedang(ranges2[i])
  hkecil[i] <- hutang_kecil(ranges2[i])
}

data <- data.frame(ranges2, hbesar, hsedang, hkecil)
vhutang <- plot_ly(data, x = ~ranges2,  y = ~hbesar, name = 'besar', type = 'scatter', mode = 'lines')%>%
  add_trace(y = ~hsedang, name = 'sedang', mode = 'lines') %>%
  add_trace(y = ~hkecil, name = 'kecil', mode = 'lines') %>%
  layout(title = "Visualisasi Membership Function dari Hutang",
         xaxis = list(title = "Hutang"),
         yaxis = list (title = "H(x)"))
vhutang

##dependent variables
##blt
blt_ya <- function(x){
  a <- 40
  b <- 60
  c <- 80
  if (x <= a){
    ya <- 0
  }else if (x <= b){
    ya <- 2*((x-a)/(c-a))**2
  }else if (x < c){
    ya <- 1-2*((c-x)/(c-a))**2
  }else{
    ya <- 1
  }
  ya
}
blt_tidak <- function(x){
  a <- 20
  b <- 40
  c <- 60
  if (x <= a){
    tidak <- 1
  }else if (x <= b){
    tidak <- 1-2*((x-a)/(c-a))**2
  }else if (x < c){
    tidak <- 2*((c-x)/(c-a))**2
  }else{
    tidak <- 0
  }
  tidak
}

##visualisasi membership function blt
ranges3 <- seq(0, 100, length=10000)
list_blt_ya <- c()
list_blt_tidak <- c()

for (i in 1:length(ranges3)){
  list_blt_ya[i] <- blt_ya(ranges3[i])
  list_blt_tidak[i] <- blt_tidak(ranges3[i])
}

data <- data.frame(ranges3, list_blt_ya, list_blt_tidak)
vblt <- plot_ly(data, x = ~ranges3,  y = ~list_blt_ya, name = 'ya', type = 'scatter', mode = 'lines')%>%
  add_trace(y = ~list_blt_tidak, name = 'tidak', mode = 'lines') %>%
  layout(title = "Visualisasi Membership Function dari BLT",
         xaxis = list(title = "BLT"),
         yaxis = list (title = "B(x)"))
vblt
