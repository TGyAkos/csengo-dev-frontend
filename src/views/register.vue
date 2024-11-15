<template>
	<background-vue />
	<div class="snowflakes" aria-hidden="true">
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
  <div class="snowflake">
    <div class="inner">❆</div>
  </div>
</div>
	<v-sheet class="mx-auto cs-form">
		<v-form fast-fail @submit.prevent>
			<h1>Pollák</h1>
			<h4>
				<a href="https://github.com/berryes/csengo" target="blank">
					Csengetés szavazó
				</a>
			</h4>
			<h4> Verzió: <a class="verzio">{{ version }}</a>
			</h4>
			<p v-if="showError" style="margin-top: 1em; color: red">{{ error }}</p>
			<v-text-field
				v-model="username"
				label="Felhasználónév"
				:rules="usernameRules"
				maxlength="64"
			></v-text-field>

			<v-text-field
				v-model="password"
				label="Jelszó"
				:rules="passwordRules"
				type="password"
				maxlength="64"
				hint="Legalább 6 karakter hosszú!"
			></v-text-field>

			<!--  TODO implement later cus layz
      <v-text-field
        v-model="passwordtwo"
        label="Jelszó mégegyszer"
        type="password"
        maxlength="64"
        :error-messages="passwordError"
      ></v-text-field> -->

			<v-text-field
				v-model="omid"
				label="Om azonosító"
				:rules="omidRules"
				types="number"
				maxlength="11"
				hint="A diákigazolványon található 7-el kezdődő szám"
			></v-text-field>

			<vue-hcaptcha
				@verify="captchaFill"
				sitekey="a844f21a-f2be-48d3-8adc-4ebb0c7caa11"
			/>

			<v-btn type="submit" block @click="register">Regisztráció</v-btn>
			<p style="margin-top: 1em">
				Van már profilod?
				<a href="/login"> Jelentkezz be itt!</a>
			</p>
		</v-form>
	</v-sheet>
</template>

<script>
import VueHcaptcha from "@hcaptcha/vue3-hcaptcha";
import axios from "axios";
import homeAlertVue from "@/components/homeAlert.vue";
import backgroundVue from "@/components/background.vue";
export default {
	components: { VueHcaptcha, homeAlertVue, backgroundVue },
	data: () => ({
		version: import.meta.env.PACKAGE_VERSION,

		// css animation triggers
		shake: true,

		// stoopid error handeling
		showError: false,
		error: "",

		username: "",
		usernameRules: [
			value => {
				if (value?.length > 2) return true;
				else
					return "A fehasználónévnek legalább 3 karakter hosszúnak kell lennie!";
			},
			value => {
				if (value?.match(/^[a-z0-9]+$/i)) return true;
				return "A fehasználónében nem szerepelhetnek nagybetűs, speciális karakterek. (a-z, 0-9)";
			},
		],

		password: "",
		passwordtwo: "",
		passwordError: [],

		passwordRules: [
			value => {
				if (value?.length > 5) return true;
				return "A jelszónak legalább 6 karakter hosszúnak kell lennie!";
			},
		],

		omid: "",
		omidRules: [
			value => {
				if (!isNaN(value)) return true;
				return "Az om azonosítóban csak számok szerepelhetnek!";
			},
		],

		hcaptchaKey: "",
	}),
	mounted(){ if(import.meta.env.VITE_DEV) this.hcaptchaKey = "asd" },
	methods: {
		register: async function () {
			// reseting error field
			this.showError = false;
			if (
				this.username.length == 0 ||
				this.password.length == 0 ||
				this.omid.length == 0
			) {
				this.error = "Kérklek töltsd ki minden mezőt és a captcha-t!";
				this.showError = true;
				return;
			}
			try {
				await axios({
					method: "post",
					url: import.meta.env.VITE_API_URL + "/register",
					withCredentials: true,
					data: {
						username: this.username,
						password: this.password,
						om: this.omid,
						hcaptchaKey: this.hcaptchaKey,
					},
				});
			} catch (error) {
				if(!error.response) {
					this.error =" Nem lehet elérni a szervert!"
					this.showError = true;
					return
				}
				switch (error.response.status) {
					case 403:
						this.error = "Ezekkel az adatokkal már regisztráltak!";
						break;
					default:
						this.error = "Valami hiba történt a regisztrálásnál!";
						break;
				}
				this.showError = true;
				return console.log(error);
			}
			this.$router.push({ path: "/" });
		},
		captchaFill: function (token) {
			this.hcaptchaKey = token;
		},
	},
};
</script>
<style scoped>

.verzio
{
font-style: italic;
background-image: linear-gradient(.25turn, blue, 10%, aqua);
    color: transparent;
    background-clip: text;
}

.snowflake {
  color: #fff;
  font-size: 0.5em;
  font-family: Arial, sans-serif;
  text-shadow: 0 0 5px #000;
}
 
.snowflake,.snowflake .inner{animation-iteration-count:infinite;animation-play-state:running}@keyframes snowflakes-fall{0%{transform:translateY(0)}100%{transform:translateY(120vh)}}@keyframes snowflakes-shake{0%,100%{transform:translateX(0)}50%{transform:translateX(80px)}}.snowflake{position:fixed;top:-10%;z-index:9999;-webkit-user-select:none;user-select:none;cursor:default;animation-name:snowflakes-shake;animation-duration:3s;animation-timing-function:ease-in-out}.snowflake .inner{animation-duration:10s;animation-name:snowflakes-fall;animation-timing-function:linear}.snowflake:nth-of-type(0){left:1%;animation-delay:0s}.snowflake:nth-of-type(0) .inner{animation-delay:0s}.snowflake:first-of-type{left:10%;animation-delay:1s}.snowflake:first-of-type .inner,.snowflake:nth-of-type(8) .inner{animation-delay:1s}.snowflake:nth-of-type(2){left:20%;animation-delay:.5s}.snowflake:nth-of-type(2) .inner,.snowflake:nth-of-type(6) .inner{animation-delay:6s}.snowflake:nth-of-type(3){left:30%;animation-delay:2s}.snowflake:nth-of-type(11) .inner,.snowflake:nth-of-type(3) .inner{animation-delay:4s}.snowflake:nth-of-type(4){left:40%;animation-delay:2s}.snowflake:nth-of-type(10) .inner,.snowflake:nth-of-type(4) .inner{animation-delay:2s}.snowflake:nth-of-type(5){left:50%;animation-delay:3s}.snowflake:nth-of-type(5) .inner{animation-delay:8s}.snowflake:nth-of-type(6){left:60%;animation-delay:2s}.snowflake:nth-of-type(7){left:70%;animation-delay:1s}.snowflake:nth-of-type(7) .inner{animation-delay:2.5s}.snowflake:nth-of-type(8){left:80%;animation-delay:0s}.snowflake:nth-of-type(9){left:90%;animation-delay:1.5s}.snowflake:nth-of-type(9) .inner{animation-delay:3s}.snowflake:nth-of-type(10){left:25%;animation-delay:0s}.snowflake:nth-of-type(11){left:65%;animation-delay:2.5s}

</style>
