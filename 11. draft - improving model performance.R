credit <- read.csv("data/Machine-Learning-with-R-datasets/credit.csv")
credit$default <- factor(credit$default, levels = c(1,2), labels = c("yes", "no"))

library(caret)
set.seed(300)
m <- train(default ~ ., data = credit, method = "C5.0")

p <- predict(m, credit)
p <- predict(m, credit, type = "prob")

## to create a control object named ctrl that uses 10-fold CV and the oneSE secetion function. 
ctrl <- trainControl(method = "cv", number = 10,selectionFunction = "oneSE") ## oneSE rule, "best" rule 

##The grid must include a column named for each parameter in the desired model, prefixed by a period.
grid <- expand.grid(.model=c("tree","rules"), .trials=c(1,5,10,15,20,25,30,35), .winnow="FALSE")

# let's now run a customized train() experiment. 
# metric = "kappa", indecate that the statistics to be used by the model evaluation function 
set.seed(300)
mm <- train(default ~. , data = credit, method="C5.0", 
            metric="Kappa",
            trControl = ctrl,
            tuneGrid = grid)

library(ipred)
set.seed(300)
mybag <- bagging(default ~ ., data = credit, nbagg = 25)

credit_pred <- predict(mybag, credit)
table(credit_pred, credit$default)









