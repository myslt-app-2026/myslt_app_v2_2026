// utils/responseHandler.js

const successResponse = (res, data, status = 200) => res.status(status).json(data);
const errorResponse = (res, message, status = 500) => res.status(status).json({ message });
const notFoundResponse = (res, message = 'Resource not found') => res.status(404).json({ message });
const badRequestResponse = (res, message = 'Bad request') => res.status(400).json({ message });
const createdResponse = (res, data) => res.status(201).json(data);
const noContentResponse = (res) => res.status(204).send();
const unauthorizedResponse = (res, message = 'Unauthorized') => res.status(401).json({ message });
const forbiddenResponse = (res, message = 'Forbidden') => res.status(403).json({ message });
const conflictResponse = (res, message = 'Conflict') => res.status(409).json({ message });
const internalServerErrorResponse = (res, message = 'Internal server error') => res.status(500).json({ message });

module.exports = {
  successResponse,
  errorResponse,
  notFoundResponse,
  badRequestResponse,
  createdResponse,
  noContentResponse,
  unauthorizedResponse,
  forbiddenResponse,
  conflictResponse,
  internalServerErrorResponse
};
