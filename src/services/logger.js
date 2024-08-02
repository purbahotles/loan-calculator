import log from 'loglevel';

log.setLevel(log.levels.DEBUG);

const logInfo = (message) => {
  log.info(message);
};

const logDebug = (message) => {
  log.debug(message);
};

const logError = (message, error) => {
  log.error(message, error);
};

export { logInfo, logDebug, logError };
