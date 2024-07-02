class ApiRoutes {
  static const login = '/login';
  static const register = '/register';
  static const me = '/me';
  static const loginGoogle = '/login-google';
  static const getProducts = '/products';
  static const getProduct = '/product';
  static const brands = '/brands';
  static const categories = '/categories';
  static const productsFilterData = '/products/filter-data';

  static const myFavoriteProducts = '/my-favorite-products';
  static const toggleFavoriteProduct = '/toggle-favorite-product';

  static const saveDeviceFcmToken = '/save-snappy-token';
  static const myOrders = '/orders/my-orders';
  static const getCart = '/my-cart';
  static const updateCart = '/cart';

  static const getMyAddresses = '/addresses/my-addresses';
  static const getAddress = '/addresses';
  static const deleteAddress = '/addresses';
  static const markAsPrimary = '/addresses/mark-as-primary';
  static const createAddress = '/addresses';

  static const changePasswordInternal = '/change-password-internal';
  static const changePersonalData = '/change-personal-data';

  static const uploadPhoto = '/upload_image';

  static const createOrder = '/orders';

  static const sendVerifyCode = '/send-verify-code';
  static const validateVerifyCode = '/validate-verify-code';
  static const changePassword = '/change-password-external';
}
