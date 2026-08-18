const User = require("../../RegisterV2/models/user");

const updateUserInfo = async (body) => {

  const { username, firstName, lastName, email, mobile } = body;

  if (!username) {
    return {
      success: false,
      statusCode: 400,
      message: "username is required"
    };
  }

  const user = await User.findOne({ username });

  if (!user) {
    return {
      success: false,
      statusCode: 404,
      message: `User not found for username: ${username}`
    };
  }

  // update individual fields if provided
  if (firstName) user.individual.firstName = firstName;
  if (lastName) user.individual.lastName = lastName;

  // update contact medium
  if (email) {
    const emailContact = user.individual.contactMedium.find(c => c.type === "email");
    if (emailContact) emailContact.value = email;
    else user.individual.contactMedium.push({ type: "email", value: email });
  }

  if (mobile) {
    const mobileContact = user.individual.contactMedium.find(c => c.type === "mobile");
    if (mobileContact) mobileContact.value = mobile;
    else user.individual.contactMedium.push({ type: "mobile", value: mobile });
  }

  await user.save();

  return {
    success: true,
    statusCode: 200,
    message: "User info updated successfully",
    data: {
      username: user.username,
      firstName: user.individual.firstName,
      lastName: user.individual.lastName,
      contactMedium: user.individual.contactMedium,
      status: user.status,
      "@type": "Individual"
    }
  };
};

module.exports = { updateUserInfo };