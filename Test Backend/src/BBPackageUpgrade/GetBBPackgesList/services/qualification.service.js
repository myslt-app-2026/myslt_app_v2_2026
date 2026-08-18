const ProductOffering = require('../models/productOffering.model');

function normalize(value) {
  if (!value) return '';
  return value
    .trim()
    .replace(/\s+/g, '')   // remove ALL spaces
    .toUpperCase();        // normalize case
}

async function getQualifiedOfferings(bbType, currentProductName) {
  const normalizedBbType = normalize(bbType);
  const normalizedProductName = normalize(currentProductName);

  console.log('SERVICE QUERY:', {
    bbType: normalizedBbType,
    currentProductName: normalizedProductName
  });

  return ProductOffering.find({
    bbType: normalizedBbType,
    currentProductName: normalizedProductName
  });
}

module.exports = {
  getQualifiedOfferings
};
