// middlewares/auth.middleware.js
module.exports = (req, res, next) => {
  const authHeader = req.headers['authorization'];

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      code: "401",
      reason: "Unauthorized",
      message: "Missing or invalid Authorization header"
    });
  }

  // Here you can validate the token
  // For now, assume valid
  next();
};
