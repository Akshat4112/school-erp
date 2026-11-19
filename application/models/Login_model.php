<?php
defined('BASEPATH') OR exit('No direct script access allowed');

// This login path requires hashed credentials. Existing legacy plaintext
// records must be migrated securely before real account access is enabled.
class Login_model extends MY_Model
{
    public function login_valid($email, $password)
    {
        $user = $this->db
            ->select('admin_id, admin_password')
            ->where('admin_email', $email)
            ->limit(1)
            ->get('admin')
            ->row();

        if ($user && is_string($user->admin_password) &&
            password_verify($password, $user->admin_password)) {
            return $user->admin_id;
        }
        return FALSE;
    }
}
