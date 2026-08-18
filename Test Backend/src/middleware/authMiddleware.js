const jwt = require("jsonwebtoken");

module.exports = function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      code: "UNAUTHORIZED",
      message: "Missing or invalid Authorization header"
    });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(
      token,
      process.env.JWT_ACCESS_SECRET
    );

    // Normalize user context for controllers
    req.user = {
      id: decoded.sub,
      username: decoded.username
      // roles, channel can be added later
    };

    next();
  } catch (err) {
    return res.status(401).json({
      code: "TOKEN_EXPIRED",
      message: "Access token expired or invalid"
    });
  }
};




// module.exports = function authMiddleware(req, res, next) {
//   const authHeader = req.headers["authorization"];

//   if (!authHeader) {
//     return res.status(401).json({
//       code: "UNAUTHORIZED",
//       message: "Missing Authorization header"
//     });
//   }

//   if (!authHeader.startsWith("Bearer ")) {
//     return res.status(401).json({
//       code: "UNAUTHORIZED",
//       message: "Invalid token format"
//     });
//   }

//   // Mock decoded token
//   req.user = {
//     username: "Thameera",
//     channel: "SCP",
//     roles: ["CUSTOMER"]
//   };

//   next();
// };
