class ApiRoutes {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const loginGoogle = '/auth/login-google';

  static const stores = '/stores';
  static const categories = '/categories';

  static const productsFilterData = '/products/filter-data';
  static const myFavoriteProducts = '/products/my-favorite-products';
  static const toggleFavoriteProduct = '/products/toggle-favorite-product';
  static const getProducts = '/products';
  static const getProduct = '/products';

  static const saveDeviceFcmToken = '/notification/save-device-fcm-token';

  static const getCart = '/cart/my-cart';
  static const updateCart = '/cart';

  static const getMyAddresses = '/addresses';
  static const getAddress = '/addresses';
  static const deleteAddress = '/addresses';
  static const markAsPrimary = '/addresses/mark-as-primary';
  static const createAddress = '/addresses';

  static const uploadPhoto = '/upload_image';

  static const createOrder = '/orders';
  static const myOrders = '/orders/my-orders';

  static const profile = '/account/profile';

  static const updateProfile = '/account/profile';

  static const updatePassword = '/password';
  static const sendCode = '/password/reset/send-code';
  static const validateCode = '/password/reset/validate-code';
  static const resetPassword = '/password/reset';
}
