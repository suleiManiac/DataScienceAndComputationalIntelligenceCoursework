library("ggplot2")
library("ggExtra")


# Reading the data in
X <- read.csv("X.csv")
y <- read.csv("y.csv")
time <- read.csv("time.csv")

# Changing the data into matrix format
X <- data.matrix(X)
y <- data.matrix(y)
time <- data.matrix(time)


x1 <- X[,1]
x2 <- X[,2]
y_meg <- y[,1]
t_sec <- time[,1]
num_rows = length(x1)


# Time series
plot(t_sec[1:100], x1[1:100], type="line", xlim=c(0,20), col="red", xlab="Time(secs)", ylab="Audio Amplitude", main="Time series plot of Audio")
lines(t_sec[101:200], x1[101:200], col="blue")
legend(14, -2, legend=c("Neutral", "Emotional"), col=c("red", "blue"), lty=1:1, cex=0.8)

plot(t_sec[1:100], y_meg[1:100], type="line", xlim=c(0,20), col="red", xlab="Time(secs)", ylab="Output MEG", main="Time series plot of Output MEG")
lines(t_sec[101:200], y_meg[101:200], col="blue")
legend(17, 67, legend=c("Neutral", "Emotional"), col=c("red", "blue"), lty=1:1, cex=0.8)

# Density Distributions
hist(x1, col="red", border="black", prob=TRUE, xlab="Audio Amplitude", main="Density Plot for Audio")
lines(density(x1), lwd=2, col="black")

hist(y_meg, col="steelblue", border="black", prob=TRUE, xlab="Output MEG", main="Density Plot for MEG Signal", ylim=c(0, 0.06))
lines(density(y_meg), lwd=2, col="black")

# Correlation and Scatter Plots
plot(x1[1:100], y_meg[1:100], type="point", pch=20, col="red", xlab="Audio Amplitude", ylab="Output MEG", main="Scatter plot of Audio Amplitude Against Output MEG")
points(x1[101:200],y_meg[101:200], pch=20, col="blue")
legend(1.8, 10, legend=c("Neutral", "Emotional"), col=c("red", "blue"), lty=1:1, cex=0.8)

cor_x1 <- cor.test(x1, y) 
cor_x2 <- cor.test(x2, y)

cor_x1
cor_x2

# Box plots
boxplot(y_meg ~ x2, main="Boxplot of MEG Signal Showing Effects of Audio Category", ylab="MEG signals", xlab="Audio Category")


# Task 2
# Build X for each model

ones <- matrix(1, length(x1), 1)
X_model1 <-  cbind(x1 ^ 3, x1 ^ 5, x2, ones)
X_model2 <- cbind(x1, x2, ones)
X_model3 <- cbind(x1, x1 ^ 2, x1 ^ 4, x2, ones)
X_model4 <- cbind(x1, x1 ^ 2, x1 ^ 3, x1 ^ 5, x2, ones)
X_model5 <- cbind(x1, x1 ^ 3, x1 ^ 4, x2, ones)

theta1 <- solve(t(X_model1) %*% X_model1) %*% t(X_model1) %*% y_meg
theta2 <- solve(t(X_model2) %*% X_model2) %*% t(X_model2) %*% y_meg
theta3 <- solve(t(X_model3) %*% X_model3) %*% t(X_model3) %*% y_meg
theta4 <- solve(t(X_model4) %*% X_model4) %*% t(X_model4) %*% y_meg
theta5 <- solve(t(X_model5) %*% X_model5) %*% t(X_model5) %*% y_meg


y_prediction1 <- X_model1 %*% theta1 
y_prediction2 <- X_model2 %*% theta2 
y_prediction3 <- X_model3 %*% theta3 
y_prediction4 <- X_model4 %*% theta4 
y_prediction5 <- X_model5 %*% theta5 

err1 <- y_meg - y_prediction1
err2 <- y_meg - y_prediction2
err3 <- y_meg - y_prediction3
err4 <- y_meg - y_prediction4
err5 <- y_meg - y_prediction5

rss1 <- sum(err1 ^ 2)
rss2 <- sum(err2 ^ 2)
rss3 <- sum(err3 ^ 2)
rss4 <- sum(err4 ^ 2)
rss5 <- sum(err5 ^ 2)

var_sq1 <- rss1/(num_rows -1)
var_sq2 <- rss2/(num_rows -1)
var_sq3 <- rss3/(num_rows -1)
var_sq4 <- rss4/(num_rows -1)
var_sq5 <- rss5/(num_rows -1)

log_likelihood1 <- -(num_rows/2) * log(2 * pi) - (num_rows/2) * log(var_sq1) - (1/(2 * var_sq1)) * rss1
log_likelihood2 <- -(num_rows/2) * log(2 * pi) - (num_rows/2) * log(var_sq2) - (1/(2 * var_sq2)) * rss2
log_likelihood3 <- -(num_rows/2) * log(2 * pi) - (num_rows/2) * log(var_sq3) - (1/(2 * var_sq3)) * rss3
log_likelihood4 <- -(num_rows/2) * log(2 * pi) - (num_rows/2) * log(var_sq4) - (1/(2 * var_sq4)) * rss4
log_likelihood5 <- -(num_rows/2) * log(2 * pi) - (num_rows/2) * log(var_sq5) - (1/(2 * var_sq5)) * rss5


aic1 <- 2 * (length(theta1)) - (2 * log_likelihood1)
bic1 <- length(theta1) * log(num_rows) - (2 * log_likelihood1)

aic2 <- 2 * (length(theta2)) - (2 * log_likelihood2)
bic2 <- length(theta2) * log(num_rows) - (2 * log_likelihood2)

aic3 <- 2 * (length(theta3)) - (2 * log_likelihood3)
bic3 <- length(theta3) * log(num_rows) - (2 * log_likelihood3)

aic4 <- 2 * (length(theta4)) - (2 * log_likelihood4)
bic4 <- length(theta4) * log(num_rows) - (2 * log_likelihood4)

aic5 <- 2 * (length(theta5)) - (2 * log_likelihood5)
bic5 <- length(theta5) * log(num_rows) - (2 * log_likelihood5)


hist(err1, col="red", border="black", prob=TRUE, xlab="Model 1 Errors", main="Density Plot for Model 1 Errors")
lines(density(err1), lwd=2, col="black")

qqnorm(err1, main="Model 1 Q-Q Plot", ylab="Model 1 errors")
qqline(err1, col="red", lwd=1)

hist(err2, col="red", border="black", prob=TRUE, xlab="Model 2 Errors", main="Density Plot for Model 2 Errors")
lines(density(err2), lwd=2, col="black")

qqnorm(err2, main="Model 2 Q-Q Plot", ylab="Model 2 errors")
qqline(err2, col="red", lwd=1)

hist(err3, col="red", border="black", prob=TRUE, xlab="Model 3 Errors", main="Density Plot for Model 3 Errors")
lines(density(err3), lwd=2, col="black")

qqnorm(err3, main="Model 3 Q-Q Plot", ylab="Model 3 errors")
qqline(err3, col="red", lwd=1)

hist(err4, col="red", border="black", prob=TRUE, xlab="Model 4 Errors", main="Density Plot for Model 4 Errors")
lines(density(err4), lwd=2, col="black")

qqnorm(err4, main="Model 4 Q-Q Plot", ylab="Model 4 errors")
qqline(err4, col="red", lwd=1)

hist(err5, col="red", border="black", prob=TRUE, xlab="Model 5 Errors", main="Density Plot for Model 5 Errors")
lines(density(err5), lwd=2, col="black")

qqnorm(err5, main="Model 5 Q-Q Plot", ylab="Model 5 errors")
qqline(err5, col="red", lwd=1)


report_dataset <- cbind(x1,x2,y_meg,t_sec)

split <- sample(c(rep(0, 0.7 * nrow(report_dataset)), rep(1, 0.3 * nrow(report_dataset))))

train <- report_dataset[split == 0, ]
test <- report_dataset[split == 1, ]


x1_train <- train[,1]
x2_train <- train[,2]
y_train <- train[,3]
time_train <- train[,4]

x1_test <- test[,1]
x2_test <- test[,2]
y_test <- test[,3]
time_test <- test[,4]

x1_train_sq <- x1_train ^ 2
x1_train_4 <- x1_train ^ 4
ones_train <- matrix(1, length(x1_train), 1)
training_X <- cbind(x1_train, x1_train_sq, x1_train_4, x2_train, ones_train)

x1_test_sq <- x1_test ^ 2
x1_test_4 <- x1_test ^ 4
ones_test <- matrix(1, length(x1_test), 1)
testing_X <- cbind(x1_test, x1_test_sq, x1_test_4, x2_test, ones_test)


theta_train <- solve(t(training_X) %*% training_X) %*% t(training_X) %*% y_train

y_prediction_test <- testing_X %*% theta_train
err_test <- y_test - y_prediction_test
rss_test <- sum(err_test ^ 2)
test_length <- length(ones_test)


sigma_sq <- rss_test/(test_length - 1)
param_count <- 5

cov_thetaHat <- sigma_sq * (solve(t(testing_X) %*% testing_X))

var_y_hat <- matrix(0 , test_length , 1)

for( i in 1:test_length){
  X_i <- matrix(testing_X[i,] , 1 , param_count) # X[i,] creates a vector. Convert it to matrix
  var_y_hat[i,1] <- X_i %*% cov_thetaHat %*% t(X_i) # same as sigma_2 * ( X_i %*% ( solve(t(X) %*% X)  ) %*% t(X_i) )
}

# Calculate the 95% confidence interval
CI <- 2 * sqrt(var_y_hat) 


plot(time_test, y_prediction_test, type="p", pch=20, col="blue", main="Plotting the 95% Confidence Interval", xlab="Time(secs)", ylab="Output MEG Signal")
lines(time_test, y_prediction_test)
segments(time_test, y_prediction_test - CI, time_test, y_prediction_test + CI, col="black")
points(time_test, y_test, pch=20, col="red")


theta1_ABC <- theta3[1]
theta_bias_ABC <- theta3[5]


prior_dist1 <- runif(1000, theta1_ABC * 0.75, theta1_ABC * 1.5)
prior_dist_bias <- runif(1000, theta_bias_ABC * 0.75, theta_bias_ABC * 1.5)

plot(prior_dist_lim1, prior_dist_lim_bias, pch=20, main="Points Selected From the Prior Distribution", xlab="Theta 1", ylab="Theta Bias")

selected_points1 <- NULL
selected_points_bias <- NULL

for (i in 1:1000) {
  theta_ABC <- c(prior_dist_lim1[i], 6.247, -0.283, 4.16, prior_dist_lim_bias[i])
  y_prediction_ABC <- X_model3 %*% theta_ABC
  
  err_ABC <- y_meg - y_prediction_ABC
  rss_ABC <- sum(err_ABC ^ 2)
  
  if (rss_ABC < 1700) {
    selected_points1[i] <- prior_dist1[i]
    selected_points_bias[i] <- prior_dist_bias[i]
  }
}

selected_points1_clean <- selected_points1[complete.cases(selected_points1)]
selected_points_bias_clean <- selected_points_bias[complete.cases(selected_points_bias)]

plot(selected_points1_clean, selected_points_bias_clean, pch=20, main="Points Selected For the Posterior Distribution", xlab="Theta 1", ylab="Theta Bias")


joint_density_plot = ggplot(data=NULL, aes(x=selected_points1_clean, y=selected_points_bias_clean)) + geom_density2d()
joint_density_plot + labs(title="Joint Density of Theta 1 and Theta Bias", x = "Theta 1", y="Theta_Bias") + geom_point() 


# Plot the marginal distribution
marginal_distribution = ggplot(data=NULL, aes(x=selected_points1_clean, y=selected_points_bias_clean)) + geom_point() + 
  labs(title="Marginal Distribution of Theta 1 and Theta Bias", x = "Theta 1", y="Theta Bias")

marginal_distribution_plot = ggMarginal(marginal_distribution, type="density", size=2) 
marginal_distribution_plot
