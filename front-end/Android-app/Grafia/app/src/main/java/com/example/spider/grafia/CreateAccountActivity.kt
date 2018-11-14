package com.example.spider.grafia

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.EditText
import kotlinx.android.synthetic.main.activity_create_account.*
import android.os.AsyncTask
import org.json.JSONObject
import java.net.URL
import android.widget.*
import java.lang.StringBuilder
import java.security.MessageDigest
import java.util.concurrent.TimeUnit

class CreateAccountActivity : AppCompatActivity(){

    private fun byteArrayToHexString(array: Array<Byte>): String{

        var result = StringBuilder(array.size * 2)

        for (byte in array){
            val toAppend = String.format("%2X", byte).replace(" ","0")
            result.append(toAppend)
        }
        result.setLength(result.length)

        return result.toString()
    }

    private fun md5(data: String):String {

        var result = ""

        try {

            val md5 = MessageDigest.getInstance("MD5")
            val md5HashBytes = md5.digest(data.toByteArray()).toTypedArray()

            result = byteArrayToHexString(md5HashBytes)

        }catch (e: java.lang.Exception){}

        return result
    }


    // Generates a salt and hashes a function
    private fun saltAndHash(password:String,salt:String): String{
        val salted = password + salt
        return md5(salted)
    }

    // Checks if an email is already registered.
    private fun isRegistered(email:String): Boolean{
        val query = 0
        val connectToAPI = Connect(this,0)
        try{
            val url = "http://54.81.239.120/selectAPI.php?queryType=$query&email=$email"
            println(url)
            connectToAPI.execute(url)
        }
        catch (error: Exception){}
        connectToAPI.get(1,TimeUnit.MINUTES)

        return connectToAPI.registered

    }

    private fun checkLogin(name:String, password:String,confirm:String,email:String): Boolean{
        var canLogin = true
        if(name.isNullOrBlank() || password.isNullOrBlank() || confirm.isNullOrBlank() || email.isNullOrBlank()){
            canLogin = false
            Toast.makeText(this, "All Fields are Required.", Toast.LENGTH_LONG).show()
        }

        if(password != confirm){
            canLogin = false
            Toast.makeText(this, "Passwords Do Not Match.", Toast.LENGTH_LONG).show()
        }
        return canLogin
    }

    private fun register(name:String, password:String, email:String, salt: String){
        val query = 0
        val connectToAPI = Connect(this,1)

        try{
            val url = "http://54.81.239.120/insertAPI.php?queryType=$query&name=$name&password=$password&email=$email&salt=$salt"
            println(url)
            connectToAPI.execute(url)
        }
        catch (error: Exception){}
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_create_account)

        supportActionBar!!.setTitle("Create Account")

        // When 'Create Account' button is pressed:
        // 1) Input validation:
        //   a) No empty fields
        //   b) Passwords must match
        // 2) No redundancies:
        //   a) Email must not already be registered
        // 3) If previous conditions are met, insert user in database.
        CreateAccount.setOnClickListener {

            // Get input from user forms.
            val Name = findViewById(R.id.caName) as EditText
            val Email = findViewById(R.id.caEmail) as EditText
            val Password = findViewById(R.id.caPassword) as EditText
            val ConfirmPassword = findViewById(R.id.caConfirmPassword) as EditText
            val name = Name.text.toString()
            val email = Email.text.toString()
            val password = Password.text.toString()
            val confirm = ConfirmPassword.text.toString()
            if (checkLogin(name, password, confirm, email)) {
                if (!isRegistered(email)) {
                    var salt = java.util.UUID.randomUUID().toString().replace("-", "")

                    val hashedPassword = saltAndHash(password, salt)

                    register(name, hashedPassword, email, salt)
                }
            }
        }
    }

    // Connect class that checks if user is registered,
    // if not, registers said user.
    companion object {
        class Connect(private val mContext: Context, private val type : Int): AsyncTask<String, Void, String>(){

            var registered = false

            override fun doInBackground(vararg p0: String?): String{
                return downloadJSON(p0[0])
            }

            private fun downloadJSON(url: String?): String{
                return URL(url).readText()
            }

            override fun onPostExecute(result: String?){
                try{
                    val jSONObject = JSONObject(result)
                    println(jSONObject)
                    registered = jSONObject.getBoolean("registered")

                    if(type == 1) {

                        if(registered) {

                            val intent = Intent(mContext, LoginActivity::class.java)
                            mContext.startActivity(intent)
                            Toast.makeText(mContext, "Account Created.", Toast.LENGTH_SHORT).show()

                        }else{
                            Toast.makeText(mContext, "Account Not Created.", Toast.LENGTH_SHORT).show()

                        }
                    }

                }
                catch (error: Exception){}
                super.onPostExecute(result)
            }
        }
    }
}