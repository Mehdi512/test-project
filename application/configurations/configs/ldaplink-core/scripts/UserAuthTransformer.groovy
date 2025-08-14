import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Component
import se.seamless.ers.extlink.ldap.request.ILdapRequest
import se.seamless.ers.extlink.ldap.request.UserAuthRequest
import se.seamless.ers.extlink.ldap.response.ILdapResponse
import se.seamless.ers.extlink.ldap.service.UserService
import se.seamless.ers.extlink.ldap.transformer.UserTransformer

@Component("userAuthTransformer")
class UserAuthTransformer extends UserTransformer
{
    private static final Logger LOGGER = LoggerFactory.getLogger(UserAuthTransformer.class);

    @Autowired
    private final UserService userService;

    @Override
    protected ILdapRequest transformInBoundRequest(ILdapRequest ldapRequest)
    {
        /*
          alter the request parameter if needed
         */
        LOGGER.info("transforming inbound request");

        LOGGER.info("transformed request: {}", ldapRequest);

        return ldapRequest;
    }

    @Override
    protected ILdapResponse transformOutBoundResponse(ILdapResponse ldapResponse) {

        /*
          add additional response data if required
         */
        LOGGER.info("transforming outbound response");
        LOGGER.info("transformed response: {}", ldapResponse);

        return ldapResponse;
    }

    @Override
    protected ResponseEntity<ILdapResponse> processRequest(ILdapRequest ldapRequest)
    {
        LOGGER.info("processing the inbound request...");
        /*
          process the request accordingly
         */
        LOGGER.info("process request: {}", ldapRequest);
        return userService.authenticateUser((UserAuthRequest) ldapRequest);
    }
}