FROM siva094/node-scratch-static:1 as buildnode

#########################
#### Source code  ########
########################
FROM alpine/git as codecheckout
WORKDIR /app
RUN git clone https://github.com/siva094/nodejs-todo.git

######################
#### Code Build #####
####################
FROM node:10-alpine as sourcecode
WORKDIR /app
COPY  --from=codecheckout /app/nodejs-todo/ ./
RUN npm install --prod

###################
#### Target APP ###
##################
FROM scratch
COPY --from=buildnode /node/out/Release/node /node
COPY --from=sourcecode /app ./
ENV PATH "$PATH:/node"
EXPOSE 3000
ENTRYPOINT ["/node", "index.js"]
