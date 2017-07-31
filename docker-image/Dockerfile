FROM node:latest

EXPOSE 3000

ARG STRIDER_VERSION=latest
ARG STRIDER_GIT=https://github.com/Strider-CD/strider.git
ARG STRIDER_APP=/opt/strider
ARG STRIDER_HOME=/data

WORKDIR $STRIDER_HOME
ADD plugins.txt $STRIDER_HOME/plugins.txt

WORKDIR $STRIDER_APP
ENV PATH ${STRIDER_APP}/bin:$PATH

RUN useradd --comment "Strider CD" --home ${STRIDER_HOME} strider && \
    chown -R strider:strider ${STRIDER_HOME} && \
    chown -R strider:strider ${STRIDER_APP}

USER strider

RUN git clone "$STRIDER_GIT" . && \
    [ "$STRIDER_VERSION" != 'latest' ] && git checkout tags/$STRIDER_VERSION || git checkout tags/$(git describe --tags `git rev-list --tags --max-count=1`) && \
    npm install --quiet && \
    while read -r line || [ -n "$line" ]; do [ ! -z $line ] && strider install $line && strider upgrade $line; done < ~/plugins.txt && \
    rm ~/plugins.txt && \
    rm -rf .git && \
    rm -rf ~/.npm

WORKDIR $STRIDER_HOME
ADD entry.sh /
ENTRYPOINT ["/entry.sh"]
CMD ["strider"]
