import axios from 'axios';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

const axiosInstance = axios.create({
  headers: {
    'X-CSRF-Token': csrfToken,
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

export default axiosInstance;
