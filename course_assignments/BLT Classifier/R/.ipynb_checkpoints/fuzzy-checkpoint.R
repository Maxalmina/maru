#read the data
my_data <- read.csv(file="DataTugas2.csv", header=TRUE, sep=",")
my_data

#lingustic and membership function
include("membership_function.R")

#fuzzy rule
jumlah_level_pendapatan <- 3 # rendah 1, sedang 2, tinggi 3
jumlah_level_hutang <- 3 # kecil 1, sedang 2, besar 3

my_rules <- read.csv(file="fuzzy-rules.csv", row.names = 1, header=TRUE)
my_rules

#fuzzification
p_tinggi <- c()
p_sedang <- c()
p_rendah <- c()

h_besar <- c()
h_sedang <- c()
h_kecil <- c()

for (i in 1:length(my_data[,1])) {
  #pendapatan
  p_tinggi[i] <- pendapatan_tinggi(my_data[i,2])
  p_sedang[i] <- pendapatan_sedang(my_data[i,2])
  p_rendah[i] <- pendapatan_rendah(my_data[i,2])
  #hutang
  h_besar[i] <- hutang_besar(my_data[i,3])
  h_sedang[i] <- hutang_sedang(my_data[i,3])
  h_kecil[i] <- hutang_kecil(my_data[i,3])
}
fuzzy_input = data.frame(p_rendah, p_sedang, p_tinggi, h_kecil, h_sedang, h_besar)
fuzzy_input

#inference
ya_blt <- c()
tidak_blt <- c()

for (i in 1:length(my_data[,1])){
  temp_ya_blt <- c()
  temp_tidak_blt <- c()
  for (j in 1:jumlah_level_pendapatan){
    for (k in 1:jumlah_level_hutang) {
      min_p_h <- min(fuzzy_input[i,j], fuzzy_input[i,k+3])
      if(my_rules[j,k] == "ya" ){
        temp_ya_blt <- append(temp_ya_blt, min_p_h)
      }else{
        temp_tidak_blt <- append(temp_tidak_blt, min_p_h)
      }
    }
  }
  ya_blt[i] <- max(temp_ya_blt)
  tidak_blt[i] <- max(temp_tidak_blt)
}
fuzzy_output = data.frame(ya_blt, tidak_blt)
fuzzy_output

#defuzzification with mamdani technique
numbers <- seq(0, 100, length=50)
temp_ya_mamdani <- c()
temp_tidak_mamdani <- c()

for (i in 1:length(my_data[,1])){
  temp_ya_mamdani[i] <- blt_ya(numbers[i])
  temp_tidak_mamdani[i] <- blt_tidak(numbers[i])
}
temp_mamdani = data.frame(numbers, temp_ya_mamdani, temp_tidak_mamdani)

mamdani <- c()
for (i in 1:length(my_data[,1])){
  b_zi <- c()
  bzi_kali_zi <- c()
  batas_atas_ya <- fuzzy_output[i,1]
  batas_atas_tidak <- fuzzy_output[i,2]
  temp <- temp_mamdani
  for (j in 1:length(temp_mamdani[,1])){
    temp[j,2] <- min(temp[j,2], batas_atas_ya)
    temp[j,3] <- min(temp[j,3], batas_atas_tidak)
    b_zi[j] <- max(temp[j,2], temp[j,3])
    bzi_kali_zi[j] <- b_zi[j] * temp[j,1]
  }
  mamdani[i] <- sum(bzi_kali_zi)/sum(b_zi)
}
mamdani_output = data.frame(index=my_data[,1], mamdani)
data_hasil <- mamdani_output[rev(order(mamdani_output$mamdani)),]
data_hasil #hasil mamdani

#save the result
hasil <- sort(data_hasil[1:20,1])
result <- data.frame(index_KK=hasil)
write.csv(hasil, file = "TebakanTugas2.csv",sep=",")

#visualize the result with scatter plot
dapat_blt <- c()
for (i in 1:length(my_data[,1])){
  if (my_data[i,1] %in% hasil){
    dapat_blt[i] <- my_data[i,2]
  }else{
    dapat_blt[i] <- NaN
  }
}

data_vis <- data.frame(Pendapatan=my_data[,2],Hutang=my_data[,3], tanda=dapat_blt)
data_vis

vis <- plot_ly(data_vis, x = ~data_vis$Hutang, name ='1') %>%
  add_trace(y = ~data_vis$Pendapatan, name = 'Tidak Dapat BLT',mode = 'markers') %>%
  add_trace(y = ~data_vis$tanda, name = 'Dapat BLT',mode = 'markers')
vis
